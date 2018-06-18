class Gym < ApplicationRecord
  belongs_to :city
  belongs_to :country
  has_many :bookings
  # belongs_to :user
  # geocoded_by :address
  # after_validation :geocode, if: :will_save_change_to_address?
end
