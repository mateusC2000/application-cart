class MarkCartAsAbandonedJob < ApplicationJob
  queue_as :default

  def perform
    CartAbandonmentService.new.perform
  end
end
