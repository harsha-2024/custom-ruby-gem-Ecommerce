# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Services
      class CatalogService
        def initialize(products_repo:, logger: MegastoreOps.logger)
          @products = products_repo
          @logger = logger
        end

        def add_product_with_variant(name:, description:, currency:, sku:, title:, price_cents:, attributes: {})
          product = Entities::Product.new(id: Utils::UUID.v4, name: name, description: description, currency: currency)
          variant = Entities::Variant.new(id: Utils::UUID.v4, sku: sku, title: title, price_cents: price_cents, attributes: attributes)
          product.variants << variant
          @products.upsert_variant(product: product, variant: variant)
          @logger.info("catalog: added product #{name} with SKU #{sku}")
          { product: product, variant: variant }
        end

        def find_by_sku(sku)
          @products.find_by_sku(sku)
        end
      end
    end
  end
end
