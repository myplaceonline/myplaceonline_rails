class FeedLoadStatus < ActiveRecord::Base
  belongs_to :identity
  
  def finished?
    self.items_complete + self.items_error == self.items_total
  end
end
