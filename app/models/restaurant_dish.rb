class RestaurantDish < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :dish_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :cost, type: ApplicationRecord::PROPERTY_TYPE_CURRENCY },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
    ]
  end

  validates :dish_name, presence: true
  
  def display
    dish_name
  end
  
  child_files
  
  def self.params
    [
      :id,
      :_destroy,
      :dish_name,
      :cost,
      :notes,
      :rating,
      restaurant_dish_files_attributes: FilesController.multi_param_names
    ]
  end


  def file_folders_parent
    :restaurant
  end

  belongs_to :restaurant
  
end
