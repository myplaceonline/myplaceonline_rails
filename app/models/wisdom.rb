class Wisdom < ActiveRecord::Base
  belongs_to :identity
  validates :name, presence: true

  def wisdom_html
    Myp.markdown_to_html(wisdom)
  end
end
