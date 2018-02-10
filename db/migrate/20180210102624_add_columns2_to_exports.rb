class AddColumns2ToExports < ActiveRecord::Migration[5.1]
  def change
    add_column :exports, :encrypt_output, :boolean
    add_column :exports, :compression_type, :integer
  end
end
