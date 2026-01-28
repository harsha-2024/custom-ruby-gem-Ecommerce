# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Repositories
      module InMemory
        class CustomersRepository
          def initialize
            @by_id = {}
          end

          def upsert(customer)
            @by_id[customer.id] = customer
          end

          def find(id)
            @by_id[id]
          end
        end
      end
    end
  end
end
