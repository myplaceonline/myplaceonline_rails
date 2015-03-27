class Hypothesis < ActiveRecord::Base
  belongs_to :question
  belongs_to :identity
end
