# frozen_string_literal: true

require 'rails/railtie'

module MegastoreOps
  class Railtie < ::Rails::Railtie
    initializer 'megastore_ops.configure' do |_app|
      MegastoreOps.logger.info('MegastoreOps Railtie loaded')
    end
  end
end
