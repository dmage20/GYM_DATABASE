class Review < ApplicationRecord
  belongs_to :gym
  belongs_to :user
  # validates :user_id, uniqueness: true
  validates :gym_id, uniqueness: { scope: :user_id, message: "You already reviewed this gym" }
  validates :content, length: { minimum: 20 }
end
