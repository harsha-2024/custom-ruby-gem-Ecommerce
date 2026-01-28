# frozen_string_literal: true

# Mock/stub implementation. Replace with Stripe SDK calls.
module MegastoreOps
  module Adapters
    module Payments
      class StripeAdapter < Adapter
        def authorize(amount_cents:, currency:, metadata: {})
          MegastoreOps.logger.info("stripe: authorize #{amount_cents} #{currency}")
          Domain::Entities::Payment.new(id: MegastoreOps::Utils::UUID.v4, amount_cents: amount_cents, currency: currency, provider: 'stripe', status: 'authorized', provider_reference: 'pi_mock')
        end
        def capture(payment_id:)
          MegastoreOps.logger.info("stripe: capture #{payment_id}")
          Domain::Entities::Payment.new(id: payment_id, amount_cents: 0, currency: 'USD', provider: 'stripe', status: 'captured')
        end
        def refund(payment_id:, amount_cents: nil)
          MegastoreOps.logger.info("stripe: refund #{payment_id} amount=#{amount_cents}")
          Domain::Entities::Payment.new(id: payment_id, amount_cents: amount_cents || 0, currency: 'USD', provider: 'stripe', status: 'refunded')
        end
      end
    end
  end
end
