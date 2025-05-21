FactoryBot.define do
  factory :cart_item do
    association :cart, factory: :shopping_cart
    product { nil }
    quantity { 0 }
  end
end
