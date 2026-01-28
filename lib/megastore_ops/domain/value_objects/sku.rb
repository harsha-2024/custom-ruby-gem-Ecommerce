# frozen_string_literal: true

module MegastoreOps
  module Domain
    module ValueObjects
      class SKU
        attr_reader :value
        def initialize(value)
          raise ArgumentError, 'sku must be non-empty' unless value && !value.strip.empty?
          @value = value
        end
        def to_s = @value
      end
    end
  end
end
