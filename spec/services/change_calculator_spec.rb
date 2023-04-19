require_relative '../../services/change_calculator'

describe Services::ChangeCalculator do
  let(:available_coins) { [0.25, 0.5, 1, 2, 3, 5] }

  describe '#call' do

    context 'when amount is valid' do
      let(:amount) { 8 }

      it 'returns change with min count of coins' do
        expect(described_class.new(amount, available_coins).call).to eq([5, 3])
      end
    end

    context 'when amount is valid' do
      let(:amount) { 8.33 }

      it 'returns false' do
        expect(described_class.new(amount, available_coins).call).to be_nil
      end
    end

    context 'when max_coin_count is set and change can be calculated' do
      let(:amount) { 20 }
      let(:max_coin_count) { 10 }

      it 'returns change with min count of coins' do
        expect(described_class.new(amount, available_coins).call(max_coin_count: max_coin_count)).to eq([5, 5, 5, 5])
      end
    end

    context 'when max_coin_count is set and change can not be calculated' do
      let(:amount) { 20 }
      let(:max_coin_count) { 3 }

      it 'returns change with min count of coins' do
        expect(described_class.new(amount, available_coins).call(max_coin_count: max_coin_count)).to be_nil
      end
    end
  end
end