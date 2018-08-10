class AddUsernameToGyms < ActiveRecord::Migration[5.2]
  def change
    add_column :gyms, :username, :string
  end
end
