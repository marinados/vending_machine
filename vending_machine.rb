class VendingMachine
  class ProductInavailable < StandardError; end

  attr_reader :product_stock, :registry

  def initialize(password, product_stock, registry)
    @password = password
    @product_stock = product_stock || ProductStock.new
    @registry = registry || Registry.new
  end

  def retrieve_product(id)
    product_stock.retrieve(id)
  end

  def process_payment(coin)
    registry.process_payment(coin)
  end

  def distribute_product(product)
    product_stock.decrement(product)
  end

  def give_change(amount)
    registry.give_change(amount)
  end
end
