# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


filepath = 'crossfit_locations.json'

serialized_gyms = File.read(filepath)
gyms = JSON.parse(serialized_gyms)
gyms.each do |gym|
  name = gym["name"]
  address = gym["address"]
  country = gym["country"]
  city = gym["city"]
  box = Gym.new(name: name, address: address, country: country, city: city)
  box.save!
end

