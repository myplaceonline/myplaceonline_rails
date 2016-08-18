class ChecklistItem < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :checklist

  validates :checklist_item_name, presence: true
  
  def display
    checklist_item_name
  end

  def final_search_result
    checklist
  end
end
