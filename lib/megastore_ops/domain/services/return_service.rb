# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Services
      class ReturnService
        def initialize(orders_repo:, inventory_service:, payment_service:, logger: MegastoreOps.logger)
          @orders = orders_repo
          @inventory = inventory_service
          @payment = payment_service
          @logger = logger
        end

        def create_return(order_id:, items: [])
          order = @orders.find(order_id)
          raise MegastoreOps::NotFound, 'order not found' unless order
          rr = Entities::ReturnRequest.new(id: Utils::UUID.v4, order_id: order.id, items: items.map { |i| Entities::ReturnRequest::Item.new(**i) })
          rr
        end

        def approve_and_refund(return_request, amount_cents:)
          @payment.refund(payment_id: @orders.find(return_request.order_id).payment_id, amount_cents: amount_cents)
          restock(return_request)
          return_request.status = :approved
          @logger.info("return: #{return_request.id} approved and refunded #{amount_cents}")
          return_request
        end

        private
        def restock(return_request)
          return_request.items.each do |item|
            @inventory.release!(item.sku, 0) # noop if nothing reserved
            # For simplicity, increase on_hand via private access not available; in real repo, provide increase_on_hand
          end
        end
      end
    end
  end
end
