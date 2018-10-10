class Gym < ApplicationRecord
  belongs_to :city, counter_cache: true
  belongs_to :country, counter_cache: true
  has_many :bookings
  has_many :bookmarks, dependent: :destroy
  has_many :reviews, dependent: :destroy
  # belongs_to :user
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def self.get(gym_name)
    self.where(name: gym_name).first
  end
end
