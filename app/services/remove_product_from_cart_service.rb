class RemoveProductFromCartService
  class ProductNotInCartError < StandardError; end

  def initialize(cart:, product_id:)
    @cart = cart
    @product_id = product_id.to_i
  end

  def call
    cart_item = @cart.cart_items.find_by(product_id: @product_id)

    raise ProductNotInCartError, "Produto não está no carrinho." unless cart_item

    cart_item.destroy!
    update_cart_total!

    @cart
  end

  private

  def update_cart_total!
    total = @cart.cart_items.includes(:product).sum { |item| item.product.price * item.quantity }
    @cart.update!(total_price: total.round(2))
  end
end
