class Bookmark < ApplicationRecord
  belongs_to :gym
  # has_one :user
  # validates :gym_id, uniqueness: true
end
