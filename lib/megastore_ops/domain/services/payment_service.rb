# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Services
      class PaymentService
        def initialize(adapter:, logger: MegastoreOps.logger)
          @adapter = adapter
          @logger = logger
        end

        def authorize(amount_cents:, currency:, metadata: {})
          @adapter.authorize(amount_cents: amount_cents, currency: currency, metadata: metadata)
        end

        def capture(payment_id:)
          @adapter.capture(payment_id: payment_id)
        end

        def refund(payment_id:, amount_cents: nil)
          @adapter.refund(payment_id: payment_id, amount_cents: amount_cents)
        end
      end
    end
  end
end
