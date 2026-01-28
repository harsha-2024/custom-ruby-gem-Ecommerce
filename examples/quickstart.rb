# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
require 'megastore_ops'

# --- Configure ---
MegastoreOps.configure do |c|
  c.currency = 'USD'
  c.payment_adapter = MegastoreOps::Adapters::Payments::TestAdapter.new
  c.shipping_adapter = MegastoreOps::Adapters::Shipping::TestAdapter.new
  c.tax_adapter      = MegastoreOps::Adapters::Tax::FlatRateAdapter.new(rate: 0.08)

  c.repositories[:products]  = MegastoreOps::Domain::Repositories::InMemory::ProductsRepository.new
  c.repositories[:customers] = MegastoreOps::Domain::Repositories::InMemory::CustomersRepository.new
  c.repositories[:carts]     = MegastoreOps::Domain::Repositories::InMemory::CartsRepository.new
  c.repositories[:orders]    = MegastoreOps::Domain::Repositories::InMemory::OrdersRepository.new
  c.repositories[:inventory] = MegastoreOps::Domain::Repositories::InMemory::InventoryRepository.new
end

cfg = MegastoreOps.configuration

catalog   = MegastoreOps::Domain::Services::CatalogService.new(products_repo: cfg.repositories[:products])
pricing   = MegastoreOps::Domain::Services::PricingService.new
cart_svc  = MegastoreOps::Domain::Services::CartService.new(carts_repo: cfg.repositories[:carts], products_repo: cfg.repositories[:products], pricing_service: pricing)
inv_svc   = MegastoreOps::Domain::Services::InventoryService.new(inventory_repo: cfg.repositories[:inventory])
pay_svc   = MegastoreOps::Domain::Services::PaymentService.new(adapter: cfg.payment_adapter)
ship_svc  = MegastoreOps::Domain::Services::ShippingService.new(adapter: cfg.shipping_adapter)
tax_svc   = MegastoreOps::Domain::Services::TaxService.new(adapter: cfg.tax_adapter)
co_svc    = MegastoreOps::Domain::Services::CheckoutService.new(carts_repo: cfg.repositories[:carts], orders_repo: cfg.repositories[:orders], products_repo: cfg.repositories[:products], pricing_service: pricing, inventory_service: inv_svc, payment_service: pay_svc, shipping_service: ship_svc, tax_service: tax_svc)
order_svc = MegastoreOps::Domain::Services::OrderService.new(orders_repo: cfg.repositories[:orders], payment_service: pay_svc, shipping_service: ship_svc, inventory_service: inv_svc)

# --- Seed catalog & inventory ---
prod = catalog.add_product_with_variant(name: 'T-Shirt', description: 'Premium cotton tee', currency: 'USD', sku: 'TS-RED-M', title: 'T-Shirt Red M', price_cents: 2500)
inv_svc.set_on_hand('TS-RED-M', 100)

# --- Create cart and add items ---
cart = cart_svc.create_cart(customer_id: 'cust_123', currency: 'USD')
cart_svc.add_item(cart_id: cart.id, sku: 'TS-RED-M', quantity: 2)

# Apply a coupon
cart.coupon_code = 'SAVE10'

# --- Checkout ---
addr = MegastoreOps::Domain::ValueObjects::Address.new(first_name: 'Jane', last_name: 'Doe', line1: '123 Main', city: 'Seattle', state: 'WA', postal_code: '98101', country: 'US', phone: '555-111-2222')
order = co_svc.checkout(cart_id: cart.id, shipping_address: addr, billing_address: addr, shipping_service_code: 'STANDARD', coupon_code: cart.coupon_code)

puts "Created Order: #{order.id}"
puts "State: #{order.state}, Total: $#{order.total_cents/100.0}"

# --- Fulfill order ---
order = order_svc.fulfill(order_id: order.id)
puts "Fulfilled with shipment: #{order.shipment_id}"
