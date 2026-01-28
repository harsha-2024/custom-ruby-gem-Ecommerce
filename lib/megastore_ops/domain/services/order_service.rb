# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Services
      class OrderService
        def initialize(orders_repo:, payment_service:, shipping_service:, inventory_service:, logger: MegastoreOps.logger)
          @orders = orders_repo
          @payment = payment_service
          @shipping = shipping_service
          @inventory = inventory_service
          @logger = logger
        end

        def fulfill(order_id:, carrier: 'TestCarrier', service: 'STANDARD')
          order = fetch(order_id)
          raise 'order not paid' unless order.state == :paid
          shipment = @shipping.purchase(address: order.shipping_address, service: service, items: order.lines.map { |l| { sku: l.sku, quantity: l.quantity } })
          order.shipment_id = shipment.id
          order.state = :fulfilled
          @orders.update(order)
          @logger.info("order: #{order.id} fulfilled with tracking #{shipment.tracking_number}")
          order
        end

        def cancel(order_id:)
          order = fetch(order_id)
          return order if %i[fulfilled closed cancelled].include?(order.state)
          @payment.refund(payment_id: order.payment_id, amount_cents: order.total_cents)
          order.state = :cancelled
          @orders.update(order)
          @logger.info("order: #{order.id} cancelled and refunded")
          order
        end

        def refund(order_id:, amount_cents: nil)
          order = fetch(order_id)
          @payment.refund(payment_id: order.payment_id, amount_cents: amount_cents)
          @logger.info("order: #{order.id} partial refund #{amount_cents || order.total_cents}")
          order
        end

        private
        def fetch(id)
          order = @orders.find(id)
          raise MegastoreOps::NotFound, 'order not found' unless order
          order
        end
      end
    end
  end
end
