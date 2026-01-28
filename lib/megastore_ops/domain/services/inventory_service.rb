# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Services
      class InventoryService
        def initialize(inventory_repo:, logger: MegastoreOps.logger)
          @inventory = inventory_repo
          @logger = logger
        end

        def set_on_hand(sku, qty)
          @inventory.set_on_hand(sku, qty)
        end

        def reserve!(sku, qty)
          @inventory.reserve(sku, qty)
          @logger.info("inventory: reserved #{qty} of #{sku}")
        end

        def release!(sku, qty)
          @inventory.release(sku, qty)
          @logger.info("inventory: released #{qty} of #{sku}")
        end

        def deduct!(sku, qty)
          @inventory.deduct(sku, qty)
          @logger.info("inventory: deducted #{qty} of #{sku}")
        end

        def available(sku)
          @inventory.available(sku)
        end
      end
    end
  end
end
