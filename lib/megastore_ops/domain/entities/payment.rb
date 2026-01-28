# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Entities
      class Payment
        attr_accessor :id, :amount_cents, :currency, :status, :provider, :provider_reference
        def initialize(id:, amount_cents:, currency:, provider: 'test', status: 'authorized', provider_reference: nil)
          @id = id
          @amount_cents = amount_cents
          @currency = currency
          @status = status
          @provider = provider
          @provider_reference = provider_reference
        end
      end
    end
  end
end
