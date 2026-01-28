# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Entities
      class Customer
        attr_accessor :id, :email, :first_name, :last_name
        def initialize(id:, email:, first_name: nil, last_name: nil)
          @id = id
          @email = email # ValueObjects::Email or string
          @first_name = first_name
          @last_name = last_name
        end
      end
    end
  end
end
