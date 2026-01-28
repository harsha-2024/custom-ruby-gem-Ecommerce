# frozen_string_literal: true

module MegastoreOps
  module Adapters
    module Payments
      class Adapter
        def authorize(amount_cents:, currency:, metadata: {})
          raise NotImplementedError
        end
        def capture(payment_id:)
          raise NotImplementedError
        end
        def refund(payment_id:, amount_cents: nil)
          raise NotImplementedError
        end
      end
    end
  end
end
