# frozen_string_literal: true

require 'logger'

require_relative 'megastore_ops/version'
require_relative 'megastore_ops/errors'
require_relative 'megastore_ops/logger'
require_relative 'megastore_ops/configuration'
require_relative 'megastore_ops/types'

# Value Objects
require_relative 'megastore_ops/domain/value_objects/money'
require_relative 'megastore_ops/domain/value_objects/address'
require_relative 'megastore_ops/domain/value_objects/email'
require_relative 'megastore_ops/domain/value_objects/sku'

# Entities
require_relative 'megastore_ops/domain/entities/product'
require_relative 'megastore_ops/domain/entities/variant'
require_relative 'megastore_ops/domain/entities/customer'
require_relative 'megastore_ops/domain/entities/cart'
require_relative 'megastore_ops/domain/entities/order'
require_relative 'megastore_ops/domain/entities/payment'
require_relative 'megastore_ops/domain/entities/shipment'
require_relative 'megastore_ops/domain/entities/return_request'

# Repositories
require_relative 'megastore_ops/domain/repositories/in_memory/products_repository'
require_relative 'megastore_ops/domain/repositories/in_memory/customers_repository'
require_relative 'megastore_ops/domain/repositories/in_memory/carts_repository'
require_relative 'megastore_ops/domain/repositories/in_memory/orders_repository'
require_relative 'megastore_ops/domain/repositories/in_memory/inventory_repository'

# Services
require_relative 'megastore_ops/domain/services/catalog_service'
require_relative 'megastore_ops/domain/services/pricing_service'
require_relative 'megastore_ops/domain/services/promotion_service'
require_relative 'megastore_ops/domain/services/cart_service'
require_relative 'megastore_ops/domain/services/inventory_service'
require_relative 'megastore_ops/domain/services/payment_service'
require_relative 'megastore_ops/domain/services/shipping_service'
require_relative 'megastore_ops/domain/services/tax_service'
require_relative 'megastore_ops/domain/services/checkout_service'
require_relative 'megastore_ops/domain/services/order_service'
require_relative 'megastore_ops/domain/services/return_service'

# Adapters
require_relative 'megastore_ops/adapters/payments/adapter'
require_relative 'megastore_ops/adapters/payments/test_adapter'
require_relative 'megastore_ops/adapters/payments/stripe_adapter'
require_relative 'megastore_ops/adapters/payments/braintree_adapter'
require_relative 'megastore_ops/adapters/shipping/adapter'
require_relative 'megastore_ops/adapters/shipping/test_adapter'
require_relative 'megastore_ops/adapters/tax/adapter'
require_relative 'megastore_ops/adapters/tax/flat_rate_adapter'

# Utils
require_relative 'megastore_ops/utils/uuid'

# Railtie (optional)
begin
  require_relative 'megastore_ops/railtie'
rescue LoadError
end

module MegastoreOps
  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def logger
      configuration.logger
    end
  end
end
