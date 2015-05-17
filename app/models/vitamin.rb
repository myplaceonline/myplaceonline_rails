class Vitamin < ActiveRecord::Base
  belongs_to :identity
  
  validates :vitamin_name, presence: true

  before_create :do_before_save
  before_update :do_before_save

  has_many :vitamin_ingredients, :foreign_key => 'parent_vitamin_id'
  accepts_nested_attributes_for :vitamin_ingredients, allow_destroy: true, reject_if: :all_blank

  # http://stackoverflow.com/a/12064875/4135310
  def vitamin_ingredients_attributes=(attributes)
    super(attributes)
    attributes.each {|key, value|
      if !value['vitamin_attributes'].blank? && !value['vitamin_attributes']['id'].blank? && value['_destroy'] != "1"
        self.vitamin_ingredients.each{|x|
          if x.vitamin.id == value['vitamin_attributes']['id'].to_i
            x.vitamin = Vitamin.find(value['vitamin_attributes']['id'])
          end
        }
      end
    }
  end

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
