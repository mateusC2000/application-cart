require 'rails_helper'

RSpec.describe CartSerializer, type: :serializer do
  describe '#serializable_hash' do
    let(:product1) { create(:product, name: 'Produto A', price: 10.0) }
    let(:product2) { create(:product, name: 'Produto B', price: 20.0) }

    let(:cart) { create(:shopping_cart, total_price: 0.0) }
    let!(:item1) { create(:cart_item, cart: cart, product: product1, quantity: 2) }
    let!(:item2) { create(:cart_item, cart: cart, product: product2, quantity: 1) }

    let(:serializer) { described_class.new(cart) }
    let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
    let(:result) { serialization.as_json }

    it 'includes the correct attributes' do
      expect(result.keys).to contain_exactly(:id, :products, :total_price)
    end

    it 'returns correct product details' do
      products = result[:products]

      expect(products.size).to eq(2)

      expect(products).to include(
        a_hash_including(
          id: product1.id,
          name: 'Produto A',
          quantity: 2,
          unit_price: 10.0,
          total_price: 20.0
        ),
        a_hash_including(
          id: product2.id,
          name: 'Produto B',
          quantity: 1,
          unit_price: 20.0,
          total_price: 20.0
        )
      )
    end

    it 'calculates and updates the total_price correctly' do
      expect(result[:total_price]).to eq(40.0)
      expect(cart.reload.total_price).to eq(40.0)
    end
  end
end
