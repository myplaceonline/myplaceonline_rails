class Checklist < ActiveRecord::Base
  belongs_to :identity
  validates :checklist_name, presence: true
  
  before_create :do_before_save
  before_update :do_before_save
  
  def display
    checklist_name
  end

  has_many :checklist_items, :dependent => :destroy
  accepts_nested_attributes_for :checklist_items, allow_destroy: true, reject_if: :all_blank

  def all_checklist_items
    ChecklistItem.where(
      checklist_id: id
    ).order(["checklist_items.position ASC"])
  end

  has_many :checklist_references, :foreign_key => 'checklist_parent_id'
  accepts_nested_attributes_for :checklist_references, allow_destroy: true, reject_if: :all_blank

  # http://stackoverflow.com/a/12064875/4135310
  def checklist_references_attributes=(attributes)
    super(attributes)
    attributes.each {|key, value|
      if !value['checklist_attributes'].blank? && !value['checklist_attributes']['id'].blank? && value['_destroy'] != "1"
        self.checklist_references.each{|x|
          if x.checklist.id == value['checklist_attributes']['id'].to_i
            x.checklist = Checklist.find(value['checklist_attributes']['id'])
          end
        }
      end
    }
  end

  def do_before_save
    Myp.set_common_model_properties(self)
  end
    
  def pre_checklist_references
    checklist_references.to_a.delete_if{|cr| !cr.pre_checklist }
  end
  
  def post_checklist_references
    checklist_references.to_a.delete_if{|cr| cr.pre_checklist }
  end
end
