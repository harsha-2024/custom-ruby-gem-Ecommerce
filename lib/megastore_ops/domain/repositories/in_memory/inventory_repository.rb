# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Repositories
      module InMemory
        class InventoryRepository
          def initialize
            @stock = Hash.new { |h, k| h[k] = { on_hand: 0, reserved: 0 } }
          end

          def set_on_hand(sku, qty)
            @stock[sku][:on_hand] = qty
          end

          def available(sku)
            data = @stock[sku]
            data[:on_hand] - data[:reserved]
          end

          def reserve(sku, qty)
            raise MegastoreOps::InsufficientStock, 'not enough stock' if available(sku) < qty
            @stock[sku][:reserved] += qty
          end

          def release(sku, qty)
            @stock[sku][:reserved] = [@stock[sku][:reserved] - qty, 0].max
          end

          def deduct(sku, qty)
            raise MegastoreOps::InsufficientStock, 'not enough stock to deduct' if @stock[sku][:on_hand] < qty
            @stock[sku][:on_hand] -= qty
            @stock[sku][:reserved] = [@stock[sku][:reserved] - qty, 0].max
          end
        end
      end
    end
  end
end
