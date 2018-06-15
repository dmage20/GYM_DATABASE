class Gym < ApplicationRecord
  belongs_to :city
  belongs_to :country
  # geocoded_by :address
  # after_validation :geocode, if: :will_save_change_to_address?
end
