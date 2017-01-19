class Vitamin < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :vitamin_name, presence: true

  child_properties(name: :vitamin_ingredients, foreign_key: "parent_vitamin_id")

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
