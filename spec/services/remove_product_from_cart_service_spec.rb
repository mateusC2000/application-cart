require 'rails_helper'

RSpec.describe RemoveProductFromCartService do
  let(:cart) { create(:shopping_cart) }
  let(:product) { create(:product, price: 10.0) }

  before do
    cart.cart_items.create!(product: product, quantity: 2)
  end

  describe '#call' do
    context 'when product quantity is more than 1' do
      it 'decreases the quantity by 1 and updates the total' do
        service = described_class.new(cart: cart, product_id: product.id)

        expect {
          service.call
        }.not_to change { cart.cart_items.count }

        item = cart.cart_items.find_by(product_id: product.id)
        expect(item.quantity).to eq(1)
        expect(cart.reload.total_price).to eq(10.0)
      end
    end

    context 'when product quantity is 1' do
      before do
        cart.cart_items.update_all(quantity: 1)
      end

      it 'removes the item from the cart' do
        service = described_class.new(cart: cart, product_id: product.id)

        expect {
          service.call
        }.to change { cart.cart_items.count }.by(-1)

        expect(cart.reload.total_price).to eq(0.0)
      end
    end

    context 'when product is not in the cart' do
      it 'raises ProductNotInCartError' do
        expect {
          described_class.new(cart: cart, product_id: -1).call
        }.to raise_error(RemoveProductFromCartService::ProductNotInCartError)
      end
    end
  end
end
