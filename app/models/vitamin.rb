class Vitamin < ActiveRecord::Base
  include AllowExistingConcern

  belongs_to :owner, class_name: Identity
  
  validates :vitamin_name, presence: true

  before_create :do_before_save
  before_update :do_before_save

  has_many :vitamin_ingredients, :foreign_key => 'parent_vitamin_id'
  accepts_nested_attributes_for :vitamin_ingredients, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :vitamin_ingredients, [{:name => :vitamin}]

  def do_before_save
    Myp.set_common_model_properties(self)
  end
  
  def display
    vitamin_name
  end
  
  def self.params
    [
      :id,
      :vitamin_name,
      :notes,
      :amount_type,
      :vitamin_amount,
      vitamin_ingredients_attributes: [
        :id,
        :_destroy,
        vitamin_attributes: [
          :id,
          :_destroy,
          :vitamin_name,
          :notes,
          :amount_type,
          :vitamin_amount
        ]
      ]
    ]
  end
end
