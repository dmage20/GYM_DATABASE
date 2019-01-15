class Wod < ApplicationRecord
  belongs_to :gym
  has_many :scores, dependent: :destroy
end
