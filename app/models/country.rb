class Country < ApplicationRecord
  has_many :cities
  has_many :gyms
end
