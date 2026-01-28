# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Services
      class ShippingService
        def initialize(adapter:, logger: MegastoreOps.logger)
          @adapter = adapter
          @logger = logger
        end

        def rates(address:, items: [])
          @adapter.rates(address: address, items: items)
        end

        def purchase(address:, service:, items: [])
          @adapter.purchase(address: address, service: service, items: items)
        end
      end
    end
  end
end
