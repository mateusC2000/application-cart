# app/serializers/cart_serializer.rb
class CartSerializer < ActiveModel::Serializer
  attributes :id, :products, :total_price

  def products
    object.cart_items.includes(:product).map do |item|
      {
        id: item.product.id,
        name: item.product.name,
        quantity: item.quantity,
        unit_price: item.product.price.to_f,
        total_price: (item.product.price * item.quantity).round(2)
      }
    end
  end

  def total_price
    total = products.sum { |p| p[:total_price] }
    object.update!(total_price: total)

    total.round(2)
  end
end
