# frozen_string_literal: true

module MegastoreOps
  module Domain
    module Entities
      class Shipment
        attr_accessor :id, :carrier, :service, :tracking_number, :label_url, :cost_cents
        def initialize(id:, carrier:, service:, tracking_number:, label_url: nil, cost_cents: 0)
          @id = id
          @carrier = carrier
          @service = service
          @tracking_number = tracking_number
          @label_url = label_url
          @cost_cents = cost_cents
        end
      end
    end
  end
end
