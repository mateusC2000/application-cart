require 'rails_helper'

RSpec.describe AddProductToCartService do
  describe '#call' do
    let(:cart) { create(:shopping_cart) }
    let(:product) { create(:product, name: 'Produto A', price: 10.0) }

    context 'when parameters are valid' do
      it 'adds a new product to the cart with the correct quantity' do
        service = described_class.new(cart: cart, product_id: product.id, quantity: 3)
        
        result = service.call

        cart_item = result.cart_items.find_by(product_id: product.id)
        expect(cart_item).not_to be_nil
        expect(cart_item.quantity).to eq(3)
      end

      it 'increments the quantity if the product is already in the cart' do
        create(:cart_item, cart: cart, product: product, quantity: 2)

        service = described_class.new(cart: cart, product_id: product.id, quantity: 3)
        result = service.call

        cart_item = result.cart_items.find_by(product_id: product.id)
        expect(cart_item.quantity).to eq(5)
      end

      it 'updates the last_interaction_at timestamp of the cart' do
        expect {
          described_class.new(cart: cart, product_id: product.id, quantity: 1).call
        }.to change { cart.reload.last_interaction_at }
      end
    end

    context 'when quantity is invalid' do
      it 'raises ArgumentError if quantity is zero' do
        service = described_class.new(cart: cart, product_id: product.id, quantity: 0)

        expect { service.call }.to raise_error(ArgumentError, /Quantidade inválida/)
      end

      it 'raises ArgumentError if quantity is negative' do
        service = described_class.new(cart: cart, product_id: product.id, quantity: -1)

        expect { service.call }.to raise_error(ArgumentError, /Quantidade inválida/)
      end
    end

    context 'when product does not exist' do
      it 'raises ActiveRecord::RecordNotFound' do
        service = described_class.new(cart: cart, product_id: 999_999, quantity: 1)

        expect { service.call }.to raise_error(ActiveRecord::RecordNotFound, /Produto não encontrado/)
      end
    end
  end
end
