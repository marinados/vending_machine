require 'rspec'
require_relative '../product_stock'

RSpec.describe ProductStock do
  let(:stock) { described_class.new }

  let(:product) { described_class::Product.new(1, 'some name', 1, 10) }

  describe '#retrieve' do

    subject { stock.retrieve(product.id) }

    it 'retrieves the instance of the product' do
      expect(subject).to be_nil
    end

    context 'when such product is in stock' do
      before { stock << product }

      it 'increments the quantity of products of the declared value' do
        expect(subject).to eq product
      end
    end
  end

  describe '#decrement' do
    let(:stock) { described_class.new << product }
    let(:product) { described_class::Product.new(1, 'some name', 1, quantity) }
    let(:quantity) { 10 }

    subject { stock.decrement(product)}

    it 'decrements the quantity of the product in question' do
      expect { subject }.to_not change(stock, :length)
      expect(product.quantity).to eq (quantity - 1)
    end

    context 'when the last product item is sold' do
      let(:quantity) { 1 }

      it 'decrements the quantity of the product in question' do
        expect { subject }.to change(stock, :length).by(-1)
        expect(product.quantity).to eq 0
      end
    end
  end
end
