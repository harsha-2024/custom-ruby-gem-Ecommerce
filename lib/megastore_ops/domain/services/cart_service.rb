# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Services
      class CartService
        def initialize(carts_repo:, products_repo:, pricing_service:, logger: MegastoreOps.logger)
          @carts = carts_repo
          @products = products_repo
          @pricing = pricing_service
          @logger = logger
        end

        def create_cart(customer_id: nil, currency: 'USD')
          cart = Entities::Cart.new(id: Utils::UUID.v4, customer_id: customer_id, currency: currency)
          @carts.create(cart)
          @logger.info("cart: created #{cart.id}")
          cart
        end

        def add_item(cart_id:, sku:, quantity: 1)
          cart = @carts.find(cart_id)
          raise MegastoreOps::NotFound, 'cart not found' unless cart
          data = @products.find_by_sku(sku)
          raise MegastoreOps::NotFound, 'sku not found' unless data
          variant = data[:variant]
          unit_price = @pricing.unit_price_cents_for(variant: variant, customer: nil, quantity: quantity)
          existing = cart.items.find { |i| i.sku == sku }
          if existing
            existing.quantity += quantity
            existing.unit_price_cents = unit_price # keep latest computed price
          else
            cart.items << Entities::Cart::Item.new(sku: sku, title: variant.title, quantity: quantity, unit_price_cents: unit_price)
          end
          @carts.update(cart)
          cart
        end

        def update_quantity(cart_id:, sku:, quantity:)
          cart = @carts.find(cart_id)
          raise MegastoreOps::NotFound, 'cart not found' unless cart
          item = cart.items.find { |i| i.sku == sku }
          raise MegastoreOps::NotFound, 'item not in cart' unless item
          item.quantity = quantity
          @carts.update(cart)
          cart
        end

        def remove_item(cart_id:, sku:)
          cart = @carts.find(cart_id)
          raise MegastoreOps::NotFound, 'cart not found' unless cart
          cart.items.reject! { |i| i.sku == sku }
          @carts.update(cart)
          cart
        end

        def totals(cart_id:, coupon_code: nil)
          cart = @carts.find(cart_id)
          raise MegastoreOps::NotFound, 'cart not found' unless cart
          subtotal = cart.items.sum { |i| i.unit_price_cents * i.quantity }
          discount = @pricing.apply_coupon(subtotal, coupon_code || cart.coupon_code)
          { subtotal_cents: subtotal, discount_cents: discount, currency: cart.currency }
        end
      end
    end
  end
end
