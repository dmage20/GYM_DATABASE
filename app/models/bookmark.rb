class Bookmark < ApplicationRecord
  belongs_to :user
  has_one :gym
end
