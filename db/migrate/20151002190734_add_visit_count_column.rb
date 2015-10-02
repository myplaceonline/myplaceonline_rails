class AddVisitCountColumn < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.tables.each do |table|
      next if table == "schema_migrations" || table == "passwords"
      # Only bother with a "top level" model. To check
      # for that, see if we can find a controller
      begin
        controller = Object.const_get(table.camelize + "Controller")
        add_column table, :visit_count, :integer
      rescue
      end
    end
  end
end
