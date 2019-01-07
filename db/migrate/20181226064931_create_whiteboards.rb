class CreateWhiteboards < ActiveRecord::Migration[5.2]
  def change
    create_table :whiteboards do |t|
      t.references :gym, foreign_key: true

      t.timestamps
    end
  end
end
