# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Services
      class CheckoutService
        def initialize(carts_repo:, orders_repo:, products_repo:, pricing_service:, inventory_service:, payment_service:, shipping_service:, tax_service:, logger: MegastoreOps.logger)
          @carts = carts_repo
          @orders = orders_repo
          @products = products_repo
          @pricing = pricing_service
          @inventory = inventory_service
          @payment = payment_service
          @shipping = shipping_service
          @tax = tax_service
          @logger = logger
        end

        def checkout(cart_id:, shipping_address:, billing_address:, shipping_service_code: 'STANDARD', coupon_code: nil, auto_capture: true)
          cart = @carts.find(cart_id)
          raise MegastoreOps::NotFound, 'cart not found' unless cart
          totals = CartTotals.new(cart: cart, pricing: @pricing, coupon_code: coupon_code)
          reserve_inventory!(cart)
          tax_cents = @tax.calculate(address: shipping_address, amount_cents: totals.subtotal_cents - totals.discount_cents)
          shipping_quote = @shipping.rates(address: shipping_address, items: cart.items).find { |r| r[:service] == shipping_service_code } || { amount_cents: 0, carrier: 'N/A', service: shipping_service_code }
          total_cents = totals.subtotal_cents - totals.discount_cents + tax_cents + shipping_quote[:amount_cents]

          payment = @payment.authorize(amount_cents: total_cents, currency: cart.currency, metadata: { cart_id: cart.id })
          @payment.capture(payment_id: payment.id) if auto_capture

          order = build_order_from_cart(cart: cart, totals: totals, tax_cents: tax_cents, shipping_quote: shipping_quote, payment: payment, shipping_address: shipping_address, billing_address: billing_address, coupon_code: coupon_code)
          @orders.create(order)

          deduct_inventory!(cart) if auto_capture
          @carts.delete(cart.id)
          @logger.info("checkout: order #{order.id} created, total #{total_cents} #{cart.currency}")
          order
        rescue Exception => e
          release_inventory!(cart) if cart
          raise e
        end

        private
        CartTotals = Struct.new(:subtotal_cents, :discount_cents, :currency, keyword_init: true) do
          def initialize(cart:, pricing:, coupon_code: nil)
            subtotal = cart.items.sum { |i| i.unit_price_cents * i.quantity }
            discount = pricing.apply_coupon(subtotal, coupon_code || cart.coupon_code)
            super(subtotal_cents: subtotal, discount_cents: discount, currency: cart.currency)
          end
        end

        def reserve_inventory!(cart)
          cart.items.each do |item|
            @inventory.reserve!(item.sku, item.quantity)
          end
        end

        def release_inventory!(cart)
          return unless cart
          cart.items.each do |item|
            @inventory.release!(item.sku, item.quantity)
          end
        end

        def deduct_inventory!(cart)
          cart.items.each do |item|
            @inventory.deduct!(item.sku, item.quantity)
          end
        end

        def build_order_from_cart(cart:, totals:, tax_cents:, shipping_quote:, payment:, shipping_address:, billing_address:, coupon_code:)
          order = Entities::Order.new(id: Utils::UUID.v4, customer_id: cart.customer_id, currency: cart.currency)
          cart.items.each do |i|
            order.lines << Entities::Order::Line.new(sku: i.sku, title: i.title, quantity: i.quantity, unit_price_cents: i.unit_price_cents, subtotal_cents: i.unit_price_cents * i.quantity)
          end
          order.subtotal_cents = totals.subtotal_cents
          order.discount_cents = totals.discount_cents
          order.tax_cents = tax_cents
          order.shipping_cents = shipping_quote[:amount_cents]
          order.total_cents = totals.subtotal_cents - totals.discount_cents + tax_cents + shipping_quote[:amount_cents]
          order.shipping_address = shipping_address
          order.billing_address = billing_address
          order.payment_id = payment.id
          order.coupon_code = coupon_code
          order.state = :paid
          order
        end
      end
    end
  end
end
