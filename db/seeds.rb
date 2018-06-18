# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Booking.destroy_all
Gym.destroy_all
City.destroy_all
Country.destroy_all

filepath = 'crossfit_locations.json'

serialized_gyms = File.read(filepath)
gyms = JSON.parse(serialized_gyms)
gyms.each do |gym|
  name = gym["name"]
  address = gym["address"]
  latitude = gym["latlon"].split(",")[0]
  longitude = gym["latlon"].split(",")[1]

  if Country.exists?(name: "#{gym["country"]}")
    country = Country.find_by_name("#{gym["country"]}")
  else
    country = Country.new(name: "#{gym["country"]}")
    country.save!
  end

  if City.exists?(name: "#{gym["city"]}")
    city = City.find_by_name("#{gym["city"]}")
  else
  city = City.new(name: "#{gym["city"]}", country_id: "#{country.id}")
  city.save!
  # binding.pry
  end

  box = Gym.new(name: name, address: address, country: country, city: city, latitude: latitude, longitude: longitude)
  box.save!

end

