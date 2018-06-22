class AddWebsiteToGyms < ActiveRecord::Migration[5.2]
  def change
    add_column :gyms, :website, :string
  end
end
