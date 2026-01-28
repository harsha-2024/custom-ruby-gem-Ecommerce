# MegastoreOps

A modular, large‑scale Ruby gem that implements end‑to‑end e‑commerce operations: catalog, pricing & promotions, carts, checkout, orders, payments, inventory, shipping, tax, refunds, and returns. Framework‑agnostic core with optional Rails integration (Railtie). Default in‑memory repositories and test adapters make it runnable without external services.

## Features
- **Catalog**: products, variants, attributes
- **Pricing**: money math, price books, simple promotions/coupons
- **Cart**: add/remove/update items, totals
- **Inventory**: stock on hand, reservations, release & deduct
- **Checkout**: tax + shipping rate + payment capture
- **Orders**: state machine (pending → paid → fulfilled → closed), cancellation
- **Payments**: pluggable adapters (Stripe/Braintree mocks, Test adapter)
- **Shipping**: rate + label purchase (mock adapters)
- **Tax**: pluggable adapters (Avalara mock)
- **Returns/Refunds**: simple RMA & restock
- **Events & Logging**: observable events, tagged logger
- **Repositories**: replace in‑memory with ActiveRecord/Sequel via interfaces

## Quickstart
```bash
# From this folder
bundle install
bundle exec ruby examples/quickstart.rb
```

## Installation (as a gem)
Add this line to your application's Gemfile:

```ruby
gem 'megastore_ops', path: '/path/to/megastore_ops' # or from your private gem server
```

And then execute:

```bash
bundle install
```

## Configuration
```ruby
MegastoreOps.configure do |c|
  c.currency = 'USD'
  c.payment_adapter = MegastoreOps::Adapters::Payments::TestAdapter.new
  c.shipping_adapter = MegastoreOps::Adapters::Shipping::TestAdapter.new
  c.tax_adapter      = MegastoreOps::Adapters::Tax::FlatRateAdapter.new(rate: 0.08)

  # swap repositories with your persistence layer
  c.repositories[:products]  = MegastoreOps::Domain::Repositories::InMemory::ProductsRepository.new
  c.repositories[:customers] = MegastoreOps::Domain::Repositories::InMemory::CustomersRepository.new
  c.repositories[:carts]     = MegastoreOps::Domain::Repositories::InMemory::CartsRepository.new
  c.repositories[:orders]    = MegastoreOps::Domain::Repositories::InMemory::OrdersRepository.new
  c.repositories[:inventory] = MegastoreOps::Domain::Repositories::InMemory::InventoryRepository.new
end
```

## Rails
The gem ships with a `Railtie` that auto‑loads under Rails. Create adapters bound to your models and assign them in the configuration during initialization.

## Status
This is a functional reference implementation intended to be extended for production. Replace in‑memory repositories and test adapters with your infra, add queues, idempotency, and security controls.
