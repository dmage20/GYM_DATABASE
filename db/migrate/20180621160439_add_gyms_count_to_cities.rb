class AddGymsCountToCities < ActiveRecord::Migration[5.2]
  def change
    add_column :cities, :gyms_count, :integer, default: 0, null: false

    City.find_each { |city| City.reset_counters(city.id, :gyms)}
  end
end
