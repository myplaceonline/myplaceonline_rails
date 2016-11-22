class Food < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :food_name, presence: true
  
  has_many :food_ingredients, :foreign_key => 'parent_food_id'
  accepts_nested_attributes_for :food_ingredients, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :food_ingredients, [{:name => :food}]

  def display
    food_name
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :food_name,
      :notes,
      :calories,
      :price,
      :weight,
      :weight_type,
      food_ingredients_attributes: [
        :id,
        :_destroy,
        food_attributes: [
          :id,
          :_destroy,
          :food_name,
          :notes,
          :calories,
          :price,
          :weight,
          :weight_type
        ]
      ],
      food_files_attributes: FilesController.multi_param_names
    ]
  end

  has_many :food_files, -> { order("position ASC, updated_at ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :food_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :food_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(food_files, [I18n.t("myplaceonline.category.foods"), display])
  end
end
