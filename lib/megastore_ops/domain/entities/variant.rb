# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Entities
      class Variant
        attr_accessor :id, :sku, :title, :price_cents, :attributes
        def initialize(id:, sku:, title:, price_cents:, attributes: {})
          @id = id
          @sku = sku
          @title = title
          @price_cents = price_cents
          @attributes = attributes # hash like {size: 'M', color: 'Blue'}
        end
      end
    end
  end
end
