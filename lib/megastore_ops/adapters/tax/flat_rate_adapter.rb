# frozen_string_literal: true

module MegastoreOps
  module Adapters
    module Tax
      class FlatRateAdapter < Adapter
        def initialize(rate: 0.0)
          @rate = rate
        end
        def calculate(address:, amount_cents:)
          (amount_cents * @rate).round
        end
      end
    end
  end
end
