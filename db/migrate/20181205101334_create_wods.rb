class CreateWods < ActiveRecord::Migration[5.2]
  def change
    create_table :wods do |t|
      t.text :instructions
      t.text :body
      t.datetime :date
      t.references :gym, foreign_key: true

      t.timestamps
    end
  end
end
