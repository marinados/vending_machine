class Registry < Array
  class ImpossibleToGiveChange < StandardError; end
  class UnsupportedCoin < StandardError; end

  class Coin < Struct.new(:type, :unit_value, :quantity)
    def receive
      self.quantity += 1
      self.unit_value
    end

    def give(number)
      self.quantity -= number
    end
  end

    COIN_VALUE = {
      '1p' => 1,
      '2p' => 2,
      '5p' => 5,
      '10p' => 10,
      '20p' => 20,
      '50p' => 50,
      '£1' => 100,
      '£2' => 200
    }.freeze

  def self.list_accepted_coins
    COIN_VALUE.keys
  end

  def self.value(coin_type)
    t = COIN_VALUE[coin_type]
    raise UnsupportedCoin if t.nil?
    t
  end

  def self.coin(coin_type)
    raise UnsupportedCoin unless list_accepted_coins.include?(coin_type)

    Coin.new(coin_type, value(coin_type), 1)
  end

  def process_payment(coin)
    coin = get_coin(coin.type)

    coin.receive
  end

  def give_change(amount)
    change_set = self.class.new
    coins_for_amount(change_set, amount)
    change_set.each do |c|
      coin = get_coin(c.type, add_new: false)
      remaining_quantity = coin.give(c.quantity)
      remove(coin) if remaining_quantity == 0
    end
    change_set
  end

  def get_coin(coin_type, add_new: true)
    select { |c| c.type == coin_type }.first || (process_new_coin(coin_type) if add_new)
  end

  private

  def process_new_coin(coin_type)
    coin = Coin.new(coin_type, self.class.value(coin_type), 0)
    self << coin
    coin
  end

  def remove(coin)
    self.delete(coin)
  end

  def coins_for_amount(registry, amount)
    raise ImpossibleToGiveChange if amount > total_cash_available

    selected = select {|c| (amount - c.unit_value) >= 0 }.
                sort { |c| amount - c.unit_value }.first

    raise ImpossibleToGiveChange if selected.nil?

    coin = registry.get_coin(selected.type, add_new: false)&.tap(&:receive) ||
                Coin.new(selected.type, selected.unit_value, 1)
    remaining_amount = amount - coin.unit_value

    raise ImpossibleToGiveChange if remaining_amount < 0

    registry << coin
    return registry if remaining_amount == 0

    coins_for_amount(registry, remaining_amount)
  end

  def total_cash_available
    sum { |c| c.unit_value * c.quantity }
  end
end
