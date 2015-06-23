class AddTypeToRewardPrograms < ActiveRecord::Migration
  def change
    add_column :reward_programs, :program_type, :integer
  end
end
