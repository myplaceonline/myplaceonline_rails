class Vitamin < MyplaceonlineActiveRecord
  include AllowExistingConcern

  validates :vitamin_name, presence: true

  has_many :vitamin_ingredients, :foreign_key => 'parent_vitamin_id'
  accepts_nested_attributes_for :vitamin_ingredients, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :vitamin_ingredients, [{:name => :vitamin}]

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
