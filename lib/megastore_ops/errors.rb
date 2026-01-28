# frozen_string_literal: true

module MegastoreOps
  class Error < StandardError; end
  class NotFound < Error; end
  class ValidationError < Error; end
  class InsufficientStock < Error; end
  class PaymentError < Error; end
end
