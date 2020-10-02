class Interface
  class NotImplemented < StandardError; end

  def initialize(machine)
    @machine = machine
  end

  def run
    welcome_message
    interact_with_machine

  rescue => e
    puts e.message
    interact_with_machine
  end

  private

  def welcome_message
    puts 'Hello! Welcome to the super vending machine.'
  end

  def interact_with_machine
    user_choice = select_your_options

    case user_choice.to_i
    when 1
      list_available_articles
    when 2
      buy_an_article
    when 3
      get_stats_for_your_machine
    when 4
      say_goodbye
    else
      unclear
    end
    interact_with_machine
  end

  def select_your_options
    puts 'What would you like to do?'
    stars
    puts 'Press the number corresponding to your selection:'
    puts '1 - view all available articles'
    puts '2 - buy an article'
    puts '3 - manage your machine'
    puts '4 - go away'
    stars
    gets.chomp
  end

  def list_available_articles
    puts 'Here are the available articles:'
    stars
    @machine.product_stock.each { |p| puts p.format_for_print }
    stars
  end

  def buy_an_article
    product = select_article
    puts "You have selected #{product.format_for_print}"

    due = product.price
    while due > 0 do
      due -= pay(due)
    end
    distribute_product(product)
    give_change(due * -1) if due < 0
  end

  def list_accepted_coins
    puts 'In order to pay, type one of the following options:'
    Registry.list_accepted_coins.each { |c| puts c }
    stars
  end

  def pay(due)
    puts "Left to pay: £#{due/100.0}"
    list_accepted_coins
    puts 'Your inserted coin:'
    coin_type = gets.chomp
    coin = Registry.coin(coin_type)
    @machine.process_payment(coin)
  rescue Registry::UnsupportedCoin => e
    puts e.message
    pay(due)
  end

  def distribute_product(product)
    @machine.distribute_product(product)
    puts 'Here you go'
    puts "Your #{product.display_name}!"
    stars
  end

  def give_change(due)
    puts "We owe you £#{due / 100.0}"
    coins = @machine.give_change(due)
    puts 'Here is your change:'
    coins.each do |c|
      puts c.type
    end
    stars
  end

  def select_article
    puts 'Select the id of the article'
    list_available_articles
    selected = gets.chomp.to_i
    @machine.retrieve_product(selected)
  end

  def get_stats_for_your_machine
    p "Here are the top 3 sales"
    @machine.get_stats.each_with_index do |(k, v), i|
      p "#{i}st place: #{k} with #{v} sales"
    end
  end

  def say_goodbye
    puts 'Thanks for coming by, see you next time'
    @machine.clear_stats
    exit
  end

  def unclear
    puts 'There must be an error, could you please repeat your choice?'
  end

  def stars
    puts '***************'
  end
end
