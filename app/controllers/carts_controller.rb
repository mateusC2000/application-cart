class CartsController < ApplicationController
  def add_item
    cart = current_cart

    cart = AddProductToCartService.new(
      cart: cart,
      product_id: params[:product_id],
      quantity: params[:quantity].to_i
    ).call

    render json: cart, serializer: CartSerializer, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue ArgumentError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def current_cart
    @current_cart ||= begin
      cart = Cart.find_by(id: session[:cart_id])

      if cart.nil?
        cart = Cart.create!(total_price: 0)
        session[:cart_id] = cart.id
      else
        cart.touch(:last_interaction_at)
      end

      cart
    end
  end
end
