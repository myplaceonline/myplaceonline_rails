class RewardProgram < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  REWARD_PROGRAM_TYPES = [
    ["myplaceonline.reward_programs.type_plane", 0],
    ["myplaceonline.reward_programs.type_hotel", 1],
    ["myplaceonline.reward_programs.type_car", 2]
  ]
  
  child_property(name: :password)
  
  child_files
  
  validates :reward_program_name, presence: true

  def display(show_default_cashback = true)
    result = reward_program_name
    result
  end
end
