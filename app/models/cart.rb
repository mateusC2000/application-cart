class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  def mark_as_abandoned
    update(abandoned: true) if inactive_for?(2.hours)
  end

  def remove_if_abandoned
    destroy if abandoned? && last_interaction_at < 3.days.ago
  end

  private

  def inactive_for?(duration)
    last_interaction_at.present? && last_interaction_at < Time.current - duration
  end
end
