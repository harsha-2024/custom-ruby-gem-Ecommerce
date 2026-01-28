# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Entities
      class ReturnRequest
        Item = Struct.new(:sku, :quantity, :reason, keyword_init: true)
        attr_accessor :id, :order_id, :items, :status
        def initialize(id:, order_id:, items: [])
          @id = id
          @order_id = order_id
          @items = items
          @status = :requested
        end
      end
    end
  end
end
