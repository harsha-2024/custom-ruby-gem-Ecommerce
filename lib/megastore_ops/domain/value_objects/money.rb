# frozen_string_literal: true

module MegastoreOps
  module Domain
    module ValueObjects
      class Money
        attr_reader :amount_cents, :currency

        def initialize(amount_cents, currency: 'USD')
          raise ArgumentError, 'amount_cents must be Integer' unless amount_cents.is_a?(Integer)
          @amount_cents = amount_cents
          @currency = currency
        end

        def +(other)
          ensure_same_currency!(other)
          Money.new(@amount_cents + other.amount_cents, currency: @currency)
        end

        def -(other)
          ensure_same_currency!(other)
          Money.new(@amount_cents - other.amount_cents, currency: @currency)
        end

        def *(mult)
          Money.new((@amount_cents * mult).round, currency: @currency)
        end

        def zero?
          @amount_cents == 0
        end

        def to_s
          format('%.2f %s', @amount_cents / 100.0, @currency)
        end

        def self.zero(currency: 'USD')
          Money.new(0, currency: currency)
        end

        private
        def ensure_same_currency!(other)
          raise ArgumentError, 'currency mismatch' unless other.currency == @currency
        end
      end
    end
  end
end
