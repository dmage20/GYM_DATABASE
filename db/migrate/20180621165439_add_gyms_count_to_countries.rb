class AddGymsCountToCountries < ActiveRecord::Migration[5.2]
  def change
    add_column :countries, :gyms_count, :integer, default: 0, null: false

    Country.find_each { |country| Country.reset_counters(country.id, :gyms)}
  end
end
