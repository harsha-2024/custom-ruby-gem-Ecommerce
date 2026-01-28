# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'megastore_ops'
  spec.version       = File.read(File.expand_path('lib/megastore_ops/version.rb', __dir__)).match(/VERSION\s*=\s*'([^']+)'/)[1]
  spec.authors       = ['Your Name']
  spec.email         = ['you@example.com']

  spec.summary       = 'Large‑scale, modular e‑commerce operations gem.'
  spec.description   = 'Catalog, pricing, carts, checkout, orders, payments, inventory, shipping, tax, refunds, and returns.'
  spec.license       = 'MIT'

  spec.files = Dir['lib/**/*', 'README.md', 'LICENSE']
  spec.require_paths = ['lib']

  spec.metadata = {
    'source_code_uri' => 'https://example.com/megastore_ops',
    'homepage_uri'    => 'https://example.com/megastore_ops'
  }

  spec.required_ruby_version = '>= 3.0'

  spec.add_development_dependency 'bundler', '>= 2.3'
end
