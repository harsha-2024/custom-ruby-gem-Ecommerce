# frozen_string_literal: true

module MegastoreOps
  class Configuration
    attr_accessor :currency, :logger, :payment_adapter, :shipping_adapter, :tax_adapter
    attr_reader :repositories

    def initialize
      @currency = 'USD'
      @logger = TaggedLogger.new($stdout)
      @repositories = {
        products: nil,
        customers: nil,
        carts: nil,
        orders: nil,
        inventory: nil
      }
    end
  end
end
