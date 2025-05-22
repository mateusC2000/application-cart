require 'rails_helper'

RSpec.describe 'Carts', type: :request do
  describe 'GET /cart' do
    let(:product1) { create(:product, name: 'Produto 1', price: 1.99) }
    let(:product2) { create(:product, name: 'Produto 2', price: 1.99) }

    before do
      post '/cart/add_item', params: { product_id: product1.id, quantity: 2 }
      post '/cart/add_item', params: { product_id: product2.id, quantity: 2 }
    end

    it 'returns the current cart with all products' do
      get '/cart'

      expect(response).to have_http_status(:ok)
      body = response.parsed_body

      expect(body).to include("id", "products", "total_price")
      expect(body["products"].size).to eq(2)

      product = body["products"].find { |p| p["id"] == product1.id }
      expect(product["name"]).to eq("Produto 1")
      expect(product["quantity"]).to eq(2)
      expect(product["unit_price"]).to eq(1.99)
      expect(product["total_price"]).to eq(3.98)

      expect(body["total_price"]).to eq(7.96)
    end
  end

  describe 'POST /cart/add_item' do
    let(:product) { create(:product) }
    let(:quantity) { 2 }

    context 'when the product exists' do
      it 'adds the item to the cart and returns the cart as JSON' do
        post '/cart/add_item', params: {
          product_id: product.id,
          quantity: quantity
        }

        expect(response).to have_http_status(:ok)
        body = response.parsed_body

        expect(body).to include("id", "products", "total_price")

        product_data = body["products"].find { |p| p["id"] == product.id }

        expect(product_data).not_to be_nil
        expect(product_data["quantity"]).to eq(quantity)
        expect(product_data["unit_price"].to_f).to eq(product.price.to_f)
        expect(product_data["total_price"].to_f).to eq((product.price * quantity).round(2))
      end
    end

    context 'when the product does not exist' do
      it 'returns a not found error' do
        post '/cart/add_item', params: {
          product_id: -1,
          quantity: quantity
        }

        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body).to include("error")
      end
    end

    context 'when the quantity is invalid' do
      it 'returns an unprocessable entity error' do
        post '/cart/add_item', params: {
          product_id: product.id,
          quantity: 'invalid'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to include("error")
      end
    end
  end
end
