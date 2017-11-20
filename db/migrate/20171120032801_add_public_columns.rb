class AddPublicColumns < ActiveRecord::Migration[5.1]
  def change
    Myp.process_models do |klass|
      add_column klass.table_name, :is_public, :boolean
    end
  end
end
