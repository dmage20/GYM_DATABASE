class AddGymRefToScores < ActiveRecord::Migration[5.2]
  def change
    add_reference :scores, :gym, foreign_key: true
  end
end
