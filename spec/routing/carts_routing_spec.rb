require "rails_helper"

RSpec.describe CartsController, type: :routing do
  describe 'routes' do
    it 'routes to #show' do
      expect(get: '/cart').to route_to(controller: 'carts', action: 'show')
    end

    it 'routes to #add_item via POST' do
      expect(post: '/cart/add_item').to route_to(controller: 'carts', action: 'add_item')
    end
  end
end 
