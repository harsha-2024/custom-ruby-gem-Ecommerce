# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Entities
      class Product
        attr_accessor :id, :name, :description, :currency, :variants

        def initialize(id:, name:, description: nil, currency: 'USD', variants: [])
          @id = id
          @name = name
          @description = description
          @currency = currency
          @variants = variants # array of Variant
        end
      end
    end
  end
end
