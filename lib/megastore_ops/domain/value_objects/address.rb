# frozen_string_literal: true

module MegastoreOps
  module Domain
    module ValueObjects
      Address = Struct.new(:first_name, :last_name, :line1, :line2, :city, :state, :postal_code, :country, :phone, keyword_init: true)
    end
  end
end
