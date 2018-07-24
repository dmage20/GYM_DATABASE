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
puts "Done Destroying"
filepath = 'crossfit_locations.json'

serialized_gyms = File.read(filepath)
gyms = JSON.parse(serialized_gyms)
gyms.each do |gym|
  name = gym["name"]
  address = gym["address"]
  latitude = gym["latlon"].split(",")[0]
  longitude = gym["latlon"].split(",")[1]
  website = gym["website"]
  state = gym["full_state"] if !gym["full_state"].blank?
  existing_states = City.where(name: gym["city"]).map { |city| city.state} if !gym["full_state"].blank?
  existing_countries = City.where(name: gym["city"]).map { |city| city.country.name}

  if Country.exists?(name: "#{gym["country"]}")
    country = Country.find_by_name("#{gym["country"]}")
  else
    country = Country.new(name: "#{gym["country"]}")
    country.save!
  end

  if City.exists?(name: "#{gym["city"]}") && !state.present? && existing_countries.include?(country.name)
    city = City.joins(:country).where('countries.name' => country.name, 'cities.name' => gym["city"]).first
    # City.find_by_name("#{gym["city"]}")
  elsif City.exists?(name: "#{gym["city"]}") && !existing_states.blank? && existing_states.include?(state)
      city = City.where(name: "#{gym["city"]}", state: gym["full_state"]).first
      # City.find_by_name("#{gym["city"]}")
  else
  city = City.new(name: "#{gym["city"]}", country_id: "#{country.id}")
  city.state = state if state.present?
  city.save!
  end

  box = Gym.new(name: name, address: address, country: country, city: city, latitude: latitude, longitude: longitude, website: website)
  box.save!

  # binding.pry if gym["city"] == "Berlin"
end

