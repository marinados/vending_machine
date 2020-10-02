class VendingMachine
  class ProductInavailable < StandardError; end

  attr_reader :product_stock, :registry, :stats

  def initialize(password, product_stock, registry, stats)
    @password = password
    @product_stock = product_stock || ProductStock.new
    @registry = registry || Registry.new
    @stats = stats
  end

  def retrieve_product(id)
    product_stock.retrieve(id)
  end

  def process_payment(coin)
    registry.process_payment(coin)
  end

  def distribute_product(product)
    product_stock.decrement(product)
    stats.add(product)
  end

  def get_stats
    stats.retrieve_top_3_products(product_stock.list_stats_keys)
  end

  def clear_stats
    stats.clear(product_stock.list_stats_keys)
  end

  def give_change(amount)
    registry.give_change(amount)
  end
end
