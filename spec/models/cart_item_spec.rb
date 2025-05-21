require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe 'associations' do
    it { should belong_to(:cart) }
    it { should belong_to(:product) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:quantity).only_integer.is_greater_than(0) }
  end

  context 'when creating a cart item' do
    let(:cart) { create(:shopping_cart) }
    let(:product) { create(:product) }

    it 'is valid with valid attributes' do
      cart_item = CartItem.new(cart: cart, product: product, quantity: 2)
      expect(cart_item).to be_valid
    end

    it 'is invalid with quantity 0' do
      cart_item = CartItem.new(cart: cart, product: product, quantity: 0)
      expect(cart_item).not_to be_valid
      expect(cart_item.errors[:quantity]).to include('must be greater than 0')
    end

    it 'is invalid with non-integer quantity' do
      cart_item = CartItem.new(cart: cart, product: product, quantity: 1.5)
      expect(cart_item).not_to be_valid
      expect(cart_item.errors[:quantity]).to include('must be an integer')
    end
  end
end
