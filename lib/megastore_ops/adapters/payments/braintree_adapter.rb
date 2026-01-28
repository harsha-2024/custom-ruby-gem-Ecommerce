# frozen_string_literal: true

# Mock/stub implementation. Replace with Braintree SDK calls.
module MegastoreOps
  module Adapters
    module Payments
      class BraintreeAdapter < Adapter
        def authorize(amount_cents:, currency:, metadata: {})
          MegastoreOps.logger.info("braintree: authorize #{amount_cents} #{currency}")
          Domain::Entities::Payment.new(id: MegastoreOps::Utils::UUID.v4, amount_cents: amount_cents, currency: currency, provider: 'braintree', status: 'authorized', provider_reference: 'bt_mock')
        end
        def capture(payment_id:)
          MegastoreOps.logger.info("braintree: capture #{payment_id}")
          Domain::Entities::Payment.new(id: payment_id, amount_cents: 0, currency: 'USD', provider: 'braintree', status: 'captured')
        end
        def refund(payment_id:, amount_cents: nil)
          MegastoreOps.logger.info("braintree: refund #{payment_id} amount=#{amount_cents}")
          Domain::Entities::Payment.new(id: payment_id, amount_cents: amount_cents || 0, currency: 'USD', provider: 'braintree', status: 'refunded')
        end
      end
    end
  end
end
