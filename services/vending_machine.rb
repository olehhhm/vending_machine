require_relative 'change_calculator'

module Services
  class VendingMachine
    module State
      INITED = :inited.freeze
      CHOOSE_PRODUCT = :choose.freeze
      TOSS_COIN = :toss.freeze
    end

    def initialize(product_store, available_coins)
      @available_coins = available_coins
      @product_store = product_store
      @current_state = State::INITED
    end

    def choose_product
      @current_state = State::CHOOSE_PRODUCT
      slow_printer "Hello, here you can see list of available products:\n".green
      puts "ID|Name|Price|Count"
      @product_store.available_products.each do |product|
        puts [product[:id], product[:name], product[:price], product[:count]].join('|')
      end
      slow_printer "\nChoose some product and write ID or Name of it:".green

      selected_product = nil
      while selected_product.nil? do
        product_name = gets.chomp

        product = @product_store.find_product product_name
        if product.nil? || product[:count] <= 0
          slow_printer "Sorry, but product ID or Name is wrong, try again:".red
          next
        end
        selected_product = product
      end
      toss_coin(selected_product)
    end

    def toss_coin product
      @current_state = State::TOSS_COIN

      slow_printer "You selected product #{product[:name]}, it's cost #{product[:price]}, \n for buy it toss a coin to your witcher:".green

      while true
        total_tossed_coins = toss_coin_proccess(product[:price])
        if product[:price] == total_tossed_coins
          change = 0
          break
        end

        total_change = total_tossed_coins - product[:price]
        change = Services::ChangeCalculator.new(total_change, @available_coins).call

        unless change
          slow_printer "Sorry but we can't calculate change for you, try to put another amount of coins:".red
          next
        end

        break
      end

      @product_store.buy_product(product[:name])
      slow_printer "Congratulations you bought #{product[:name]}".green
      slow_printer "Here your change in coins: #{change.join(', ')}".green if change.is_a? Array
      slow_printer "Now, you will be moved to choose product step".yellow
      sleep(1)
      choose_product
    end

    private

    def toss_coin_proccess product_price
      total_tossed_coins = 0.0
      while true
        tossed_coins = gets.chomp.to_f
        total_tossed_coins += tossed_coins

        slow_printer "You already tossed #{total_tossed_coins} coin's".yellow
        if total_tossed_coins < product_price
          slow_printer "Total amount of coins is not enough, \n product price is #{product_price}, \n toss more coins to your witcher:".red
          next
        end

        break
      end

      total_tossed_coins
    end
  end
end