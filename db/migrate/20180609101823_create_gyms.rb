class CreateGyms < ActiveRecord::Migration[5.2]
  def change
    create_table :gyms do |t|
      t.references :country, foreign_key: true
      t.references :city, foreign_key: true
      # t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
