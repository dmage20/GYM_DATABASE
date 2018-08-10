class AddHashtagToGyms < ActiveRecord::Migration[5.2]
  def change
    add_column :gyms, :hashtag, :string
  end
end
