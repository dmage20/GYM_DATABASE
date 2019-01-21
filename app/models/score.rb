class Score < ApplicationRecord
  belongs_to :user
  belongs_to :wod
  belongs_to :gym
  validates_presence_of :time
  validates :wod_id, uniqueness: { scope: :user_id, message: "score already posted." }
end
