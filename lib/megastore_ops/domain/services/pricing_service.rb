# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Services
      class PricingService
        def initialize(logger: MegastoreOps.logger)
          @logger = logger
        end

        def unit_price_cents_for(variant:, customer: nil, quantity: 1)
          # placeholder for price books / tiers. Apply simple bulk discount example
          price = variant.price_cents
          if quantity >= 10
            price = (price * 0.9).round # 10% off for 10+
          end
          price
        end

        def apply_coupon(subtotal_cents, code)
          return 0 unless code
          # simple coupon example: SAVE10 => $10 off, SAVE10P => 10% off
          case code
          when 'SAVE10' then 1000
          when 'SAVE10P' then (subtotal_cents * 0.10).round
          else 0
          end
        end
      end
    end
  end
end
