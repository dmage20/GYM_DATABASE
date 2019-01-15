class Score < ApplicationRecord
  belongs_to :user
  belongs_to :wod
  belongs_to :gym
end
