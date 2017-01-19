class FeedLoadStatus < ApplicationRecord
  belongs_to :identity
  
  def finished?
    self.items_complete + self.items_error == self.items_total
  end
  
  def items_progressed
    self.items_complete + self.items_error
  end
end
