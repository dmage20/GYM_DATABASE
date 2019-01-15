class Gym < ApplicationRecord
  belongs_to :city, counter_cache: true
  belongs_to :country, counter_cache: true
  has_many :bookings
  has_many :bookmarks, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :admins, dependent: :destroy
  has_many :scores, dependent: :destroy
  has_one :whiteboard
  # belongs_to :user
  has_many :users, through: :admin
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def self.get(gym_name)
    self.where(name: gym_name).first
  end
end
