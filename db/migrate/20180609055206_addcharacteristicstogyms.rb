class Addcharacteristicstogyms < ActiveRecord::Migration[5.2]
  def change
    add_column :gyms, :name, :string
    add_column :gyms, :address, :string
    add_column :gyms, :country, :string
    add_column :gyms, :city, :string
    add_column :gyms, :latitude, :float
    add_column :gyms, :longitude, :float
  end
end
