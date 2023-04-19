require_relative '../../store/products'

describe Store::Products do
  let(:default_products) { [
    {id: 1, name: :banana, count: 5, price: 15},
    {id: 2, name: :apple, count: 2, price: 100500},
    {id: 3, name: :pineapple, count: 4, price: 150},
    {id: 4, name: :orange, count: 3, price: 2}
  ] }

  describe '#available_products' do
    context 'when it\'s only created' do
      it 'returns default list of products' do
        expect(described_class.new.available_products).to eq(default_products)
      end
    end

    context 'when some of product was changed' do
      let(:instance) { described_class.new }
      it 'returns default list of products' do
        instance.buy_product(:banana)
        expect(instance.available_products).to eq([
          {id: 1, name: :banana, count: 4, price: 15},
          {id: 2, name: :apple, count: 2, price: 100500},
          {id: 3, name: :pineapple, count: 4, price: 150},
          {id: 4, name: :orange, count: 3, price: 2}
        ])
      end
    end

    context 'when some of product was changed but reset was call' do
      let(:instance) { described_class.new }
      it 'returns default list of products' do
        instance.buy_product(:banana)
        instance.reset
        expect(instance.available_products).to eq(default_products)
      end
    end
  end

  describe '#find_product' do
    context 'when product with that name exists' do
      let(:name) { :banana }
      let(:product) { {id: 1, name: :banana, count: 5, price: 15} }
      it 'returns product' do
        expect(described_class.new.find_product(name)).to eq(product)
      end
    end

    context 'when product with that ID exists' do
      let(:id) { 1 }
      let(:product) { {id: 1, name: :banana, count: 5, price: 15} }
      it 'returns product' do
        expect(described_class.new.find_product(id)).to eq(product)
      end
    end

    context 'when product is not exist' do
      let(:id) { 55 }
      it 'returns nil' do
        expect(described_class.new.find_product(id)).to be_nil
      end
    end
  end
end