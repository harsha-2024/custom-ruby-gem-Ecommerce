# frozen_string_literal: true

module MegastoreOps
  module Types
    CURRENCIES = %w[USD EUR GBP SGD INR JPY AUD CAD].freeze
    PaymentStatus = Struct.new(:value) do
      def to_s = value
    end
    ORDER_STATES = %i[pending paid fulfilled closed cancelled].freeze
  end
end
