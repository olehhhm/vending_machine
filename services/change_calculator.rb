module Services
  class ChangeCalculator
    def initialize(change_amount, available_coins)
      @change_amount = change_amount
      @available_coins = available_coins.sort.reverse
    end

    def call(max_coin_count: 100)
      # in real cases it's better to filter coins that can be used and calculate change only with them
      return nil unless @available_coins.any?{|coin| @change_amount % coin == 0}
      # check if we have coin with same amount as change
      return [@change_amount] if @available_coins.include? @change_amount

      coin_limit = 2
      max_coin = @available_coins.max

      while coin_limit <= max_coin_count
        # check if it even posible to return this change with this coin limit
        if @change_amount / coin_limit > max_coin
          coin_limit += 1
          next
        end

        posible_coins = calculate_change_with_coin_limit(coin_limit)
        return posible_coins unless posible_coins.nil?

        coin_limit += 1
      end
    end

    private

    def calculate_change_with_coin_limit coin_count_limit
      change_amount_balance = @change_amount
      posible_coins = []
      for i in 1..coin_count_limit do
        closest = @available_coins.detect{|coin| coin <= change_amount_balance}
        break if closest.nil?

        posible_coins << closest
        change_amount_balance -= closest
      end

      return posible_coins if change_amount_balance.zero?

      nil
    end
  end
end