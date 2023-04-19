module Store
  class Products
    DEFAULT_PRODUCTS_LIST = [
      {id: 1, name: :banana, count: 5, price: 15},
      {id: 2, name: :apple, count: 2, price: 100500},
      {id: 3, name: :pineapple, count: 4, price: 150},
      {id: 4, name: :orange, count: 3, price: 2}
    ].freeze

    def initialize
      reset
    end

    def reset
      @product_list = DEFAULT_PRODUCTS_LIST.map(&:clone)
    end

    def available_products
      # clone it for preventing access and modifying
      @product_list.select{|v| v[:count] > 0}.map(&:clone)
    end

    def buy_product(name_or_id)
      product = find_product_with_ref(name_or_id)
      return false if product.nil? || product[:count] <= 0

      product[:count] -= 1
    end

    def find_product(name_or_id)
      # clone it for preventing access and modifying
      @product_list.detect{|v| v[:id] == name_or_id.to_s.to_i || v[:name] == name_or_id}&.clone
    end

    private

    def find_product_with_ref(name_or_id)
      @product_list.detect{|v| v[:id] == name_or_id.to_s.to_i || v[:name] == name_or_id}
    end
  end
end