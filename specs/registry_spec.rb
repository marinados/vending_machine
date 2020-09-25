require 'rspec'
require_relative '../registry'

RSpec.describe Registry do
  let(:registry) { described_class.new }

  describe '#process_payment' do
    let(:coin) { described_class::Coin.new('2p', 2, 1) }

    subject { registry.process_payment(coin)}
    it 'increments the quantity of coins of the declared value' do
      expect { subject }.to change(registry, :length).by(1)
      expect(registry).to match_array([coin])
    end

    context 'when the same value coin is already present' do
      let(:registry) { described_class.new << coin }

      it 'increments the quantity of coins of the declared value' do
        expect { subject }.to_not change(registry, :length)
        expect(coin.quantity).to eq 2
      end
    end
  end

  describe '#give_change' do
    let(:coin) { described_class::Coin.new('5p', 5, 1) }
    let(:change_coin) { described_class::Coin.new('5p', 5, 1) }
    let(:expected_change) { described_class.new << change_coin }
    before do
      registry << coin
    end

    subject { registry.give_change(coin.unit_value) }

    it 'removes the only coin from the registry' do
      expect(subject).to match_array expected_change
      expect(registry).to be_empty
    end

    context 'when change cannot be given because of insufficient funds' do
      subject { registry.give_change(100) }

      it 'raises an error' do
        expect { subject }.to raise_error(described_class::ImpossibleToGiveChange)
      end
    end
  end

  describe '#self.value' do
    subject { described_class.value(coin_type) }

    context 'for supported coin_type' do
      let(:coin_type) { '5p' }

      it 'returns the correct value' do
        expect(subject).to eq 5
      end
    end

    context 'for unsupported coin_type' do
      let(:coin_type) { '$5' }

      it 'returns the correct value' do
        expect { subject}.to raise_error(described_class::UnsupportedCoin)
      end
    end
  end

  describe '#self.coin' do
    subject { described_class.coin(coin_type) }

    context 'for supported coin_type' do
      let(:coin_type) { '5p' }

      it 'returns the correct value' do
        expect(subject).to be_an_instance_of(described_class::Coin)
      end
    end

    context 'for unsupported coin_type' do
      let(:coin_type) { '$5' }

      it 'returns the correct value' do
        expect { subject}.to raise_error(described_class::UnsupportedCoin)
      end
    end
  end
end
