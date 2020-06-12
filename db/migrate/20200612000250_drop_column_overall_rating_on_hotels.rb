class DropColumnOverallRatingOnHotels < ActiveRecord::Migration[5.2]
  def change
    remove_column :hotels, :overall_rating
  end
end
