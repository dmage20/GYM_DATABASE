class City < ApplicationRecord
  belongs_to :country
  has_many :gyms
  attr_accessor :url
end
