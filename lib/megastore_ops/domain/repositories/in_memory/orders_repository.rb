# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Repositories
      module InMemory
        class OrdersRepository
          def initialize
            @by_id = {}
          end

          def create(order)
            @by_id[order.id] = order
          end

          def find(id)
            @by_id[id]
          end

          def update(order)
            @by_id[order.id] = order
          end
        end
      end
    end
  end
end
