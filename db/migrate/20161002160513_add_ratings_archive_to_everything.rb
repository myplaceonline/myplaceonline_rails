class AddRatingsArchiveToEverything < ActiveRecord::Migration
  def change
    Myp.process_models do |klass|
      has_archived = false
      has_rating = false
      klass.columns.each do |column|
        if column.name == "archived"
          has_archived = true
        elsif column.name == "rating"
          has_rating = true
        end
      end
      if !has_archived
        add_column klass.table_name.to_sym, :archived, :datetime
      end
      if !has_rating
        add_column klass.table_name.to_sym, :rating, :integer
      end
    end
  end
end
