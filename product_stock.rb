class ProductStock < Array
  class Product < Struct.new(:id, :display_name, :price, :quantity)
    class NonSufficientPayment < StandardError
      MESSAGE = 'You need to add %s'
    end

    def format_for_print
      "#{id} - #{display_name}, price: £#{price_in_gbp}"
    end

    def price_in_gbp
     price / 100.0
    end
  end

  def list_stats_keys
    map { |p| p.display_name }
  end

  def list_daily_stats_keys
    map { |p| (1..7).each { |w_d| "#{w_d}_#{p.display_name}" } }
  end

  def retrieve(product_id)
    select { |p| p.id == product_id }.first
  end

  def decrement(product)
    product.quantity -= 1
    self.delete(product) if product.quantity == 0
  end
end
