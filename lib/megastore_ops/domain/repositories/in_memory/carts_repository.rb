# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Repositories
      module InMemory
        class CartsRepository
          def initialize
            @by_id = {}
          end

          def create(cart)
            @by_id[cart.id] = cart
          end

          def find(id)
            @by_id[id]
          end

          def update(cart)
            @by_id[cart.id] = cart
          end

          def delete(id)
            @by_id.delete(id)
          end
        end
      end
    end
  end
end
