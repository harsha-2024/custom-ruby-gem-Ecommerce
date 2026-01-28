# frozen_string_literal: true

module MegastoreOps
  module Adapters
    module Shipping
      class TestAdapter < Adapter
        def rates(address:, items: [])
          [
            { carrier: 'TestCarrier', service: 'STANDARD', amount_cents: 500 },
            { carrier: 'TestCarrier', service: 'EXPRESS', amount_cents: 1500 }
          ]
        end

        def purchase(address:, service:, items: [])
          Entities::Shipment.new(id: MegastoreOps::Utils::UUID.v4, carrier: 'TestCarrier', service: service, tracking_number: "TEST-#{rand(100000..999999)}", label_url: nil, cost_cents: service == 'EXPRESS' ? 1500 : 500)
        end
      end
    end
  end
end
