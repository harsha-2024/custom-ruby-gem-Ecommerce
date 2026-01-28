# frozen_string_literal: true

module MegastoreOps
  module Adapters
    module Shipping
      class Adapter
        def rates(address:, items: [])
          raise NotImplementedError
        end
        def purchase(address:, service:, items: [])
          raise NotImplementedError
        end
      end
    end
  end
end
