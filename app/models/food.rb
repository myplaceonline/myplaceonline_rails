class Food < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :food_name, presence: true
  
  child_properties(name: :food_ingredients, foreign_key: "parent_food_id")

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

  child_properties(name: :food_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(food_files, [I18n.t("myplaceonline.category.foods"), display])
  end
end
