# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Entities
      class Cart
        Item = Struct.new(:sku, :title, :quantity, :unit_price_cents, keyword_init: true)
        attr_accessor :id, :customer_id, :currency, :items, :coupon_code

        def initialize(id:, customer_id: nil, currency: 'USD', items: [])
          @id = id
          @customer_id = customer_id
          @currency = currency
          @items = items # array of Item
          @coupon_code = nil
        end
      end
    end
  end
end
