# frozen_string_literal: true

module MegastoreOps
  module Adapters
    module Tax
      class Adapter
        def calculate(address:, amount_cents:)
          raise NotImplementedError
        end
      end
    end
  end
end
