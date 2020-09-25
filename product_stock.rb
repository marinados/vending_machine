class ProductStock < Array
  class Product < Struct.new(:id, :display_name, :price, :quantity)
    class NonSufficientPayment < StandardError
      MESSAGE = 'You need to add %s'
    end

    def format_for_print
      "#{id} - #{display_name}, price: £#{price_in_gbp}"
    end

    def price_in_gbp
     price/100.0
    end
  end

  def retrieve(product_id)
    select { |p| p.id == product_id }.first
  end

  def decrement(product)
    product.quantity -= 1
    self.delete(product) if product.quantity == 0
  end
end
