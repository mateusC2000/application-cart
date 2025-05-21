class AddProductToCartService
  def initialize(cart:, product_id:, quantity:)
    @cart = cart
    @product_id = product_id
    @quantity = quantity.to_i
  end

  def call
    raise ArgumentError, "Quantidade inválida" if @quantity <= 0

    product = Product.find_by(id: @product_id)
    raise ActiveRecord::RecordNotFound, "Produto não encontrado" unless product

    cart_item = @cart.cart_items.find_or_initialize_by(product: product)

    if cart_item.new_record?
      cart_item.quantity = @quantity
    else
      cart_item.quantity += @quantity
    end

    cart_item.save!
    @cart.touch(:last_interaction_at)

    @cart
  end
end
