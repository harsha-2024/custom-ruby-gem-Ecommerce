# frozen_string_literal: true

module MegastoreOps
  module Domain
    module ValueObjects
      class Email
        attr_reader :value
        def initialize(value)
          raise ArgumentError, 'invalid email' unless value =~ /\A[^\s@]+@[^\s@]+\.[^\s@]+\z/
          @value = value
        end
        def to_s = @value
      end
    end
  end
end
