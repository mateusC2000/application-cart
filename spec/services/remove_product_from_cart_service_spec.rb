require 'rails_helper'

RSpec.describe RemoveProductFromCartService do
  let(:cart) { create(:shopping_cart) }
  let(:product) { create(:product, price: 10.0) }

  before do
    cart.cart_items.create!(product: product, quantity: 2)
  end

  describe '#call' do
    it 'removes the product and updates the cart total' do
      expect {
        described_class.new(cart: cart, product_id: product.id).call
      }.to change { cart.cart_items.count }.by(-1)

      expect(cart.reload.total_price).to eq(0)
    end

    it 'raises error if product is not in the cart' do
      expect {
        described_class.new(cart: cart, product_id: -1).call
      }.to raise_error(RemoveProductFromCartService::ProductNotInCartError)
    end
  end
end
