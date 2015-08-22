class ChecklistItem < MyplaceonlineActiveRecord
  belongs_to :checklist

  validates :checklist_item_name, presence: true
  
  def display
    checklist_item_name
  end
end
