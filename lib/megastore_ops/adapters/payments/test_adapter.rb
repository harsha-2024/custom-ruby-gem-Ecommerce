# frozen_string_literal: true

module MegastoreOps
  module Adapters
    module Payments
      class TestAdapter < Adapter
        def initialize
          @store = {}
        end

        def authorize(amount_cents:, currency:, metadata: {})
          id = MegastoreOps::Utils::UUID.v4
          payment = MegastoreOps::Domain::Entities::Payment.new(id: id, amount_cents: amount_cents, currency: currency, provider: 'test', status: 'authorized', provider_reference: 'TEST-REF')
          @store[id] = payment
          payment
        end

        def capture(payment_id:)
          p = @store[payment_id]
          raise MegastoreOps::PaymentError, 'payment not found' unless p
          p.status = 'captured'
          p
        end

        def refund(payment_id:, amount_cents: nil)
          p = @store[payment_id]
          raise MegastoreOps::PaymentError, 'payment not found' unless p
          # no-op for test
          p.status = 'refunded'
          p
        end
      end
    end
  end
end
