# frozen_string_literal: true
require 'securerandom'

module MegastoreOps
  module Utils
    module UUID
      def self.v4
        SecureRandom.uuid
      end
    end
  end
end
