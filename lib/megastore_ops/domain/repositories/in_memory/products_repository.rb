# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Repositories
      module InMemory
        class ProductsRepository
          def initialize
            @by_sku = {}
          end

          def upsert_variant(product:, variant:)
            @by_sku[variant.sku] = { product: product, variant: variant }
          end

          def find_by_sku(sku)
            @by_sku[sku]
          end

          def all_skus
            @by_sku.keys
          end
        end
      end
    end
  end
end
