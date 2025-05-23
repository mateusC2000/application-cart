require 'rails_helper'

RSpec.describe CartAbandonmentService do
  let!(:active_cart) { create(:shopping_cart, abandoned: false, last_interaction_at: 2.hours.ago) }
  let!(:cart_to_abandon) { create(:shopping_cart, abandoned: false, last_interaction_at: 4.hours.ago) }
  let!(:recently_abandoned_cart) { create(:shopping_cart, abandoned: true, abandoned_at: 5.days.ago) }
  let!(:old_abandoned_cart) { create(:shopping_cart, abandoned: true, abandoned_at: 8.days.ago) }

  subject(:service) { described_class.new }

  describe '#perform' do
    it 'marks carts with more than 3 hours of inactivity as abandoned' do
      service.perform
      expect(cart_to_abandon.reload.abandoned).to be true
      expect(cart_to_abandon.abandoned_at).not_to be_nil

      expect(active_cart.reload.abandoned).to be false
    end

    it 'deletes carts abandoned for more than 7 days' do
      expect { service.perform }.to change { Cart.exists?(old_abandoned_cart.id) }.from(true).to(false)
    end

    it 'does not delete carts abandoned for less than 7 days' do
      service.perform
      expect(Cart.exists?(recently_abandoned_cart.id)).to be true
    end
  end
end