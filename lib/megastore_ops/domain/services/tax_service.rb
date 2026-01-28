# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Services
      class TaxService
        def initialize(adapter:, logger: MegastoreOps.logger)
          @adapter = adapter
          @logger = logger
        end

        def calculate(address:, amount_cents:)
          @adapter.calculate(address: address, amount_cents: amount_cents)
        end
      end
    end
  end
end
