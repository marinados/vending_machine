require 'faker'
require_relative 'interface'
require_relative 'product_stock'
require_relative 'registry'
require_relative 'vending_machine'

machine_password = 'very_complex_password'

product_stock = ProductStock.new
id = 1
10.times do
  product_stock << ProductStock::Product.new(id, Faker::Beer.name, rand(50..450), rand(10..20))
  id += 1
end


registry = Registry.new
Registry::COIN_VALUE.each do |name, unit_value|
  registry << Registry::Coin.new(name,  unit_value, rand(1..50))
end

machine = VendingMachine.new(machine_password, product_stock, registry)

interface = Interface.new(machine)

interface.run
