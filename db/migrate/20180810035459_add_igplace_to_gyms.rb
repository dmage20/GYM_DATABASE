class AddIgplaceToGyms < ActiveRecord::Migration[5.2]
  def change
    add_column :gyms, :igplace, :string
  end
end
