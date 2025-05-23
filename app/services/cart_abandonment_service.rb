class CartAbandonmentService
  ABANDONED_THRESHOLD = 3.hours
  DELETE_THRESHOLD = 7.days

  def perform
    mark_abandoned_carts
    delete_old_abandoned_carts
  end

  private

  def mark_abandoned_carts
    carts_to_abandon = Cart.where(abandoned: false)
                           .where("last_interaction_at < ?", Time.current - ABANDONED_THRESHOLD)
    carts_to_abandon.find_each do |cart|
      cart.update!(abandoned: true, abandoned_at: Time.current)
    end
  end

  def delete_old_abandoned_carts
    carts_to_delete = Cart.where(abandoned: true)
                          .where("abandoned_at < ?", Time.current - DELETE_THRESHOLD)
    carts_to_delete.find_each(&:destroy!)
  end
end
