# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Entities
      class Order
        Line = Struct.new(:sku, :title, :quantity, :unit_price_cents, :subtotal_cents, keyword_init: true)
        attr_accessor :id, :state, :customer_id, :currency, :lines, :subtotal_cents, :discount_cents,
                      :tax_cents, :shipping_cents, :total_cents, :shipping_address, :billing_address,
                      :payment_id, :shipment_id, :coupon_code

        def initialize(id:, customer_id:, currency: 'USD')
          @id = id
          @customer_id = customer_id
          @currency = currency
          @state = :pending
          @lines = []
          @subtotal_cents = 0
          @discount_cents = 0
          @tax_cents = 0
          @shipping_cents = 0
          @total_cents = 0
          @shipping_address = nil
          @billing_address = nil
          @payment_id = nil
          @shipment_id = nil
          @coupon_code = nil
        end
      end
    end
  end
end
