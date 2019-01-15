class AddTimeToScores < ActiveRecord::Migration[5.2]
  def change
    add_column :scores, :time, :datetime
  end
end
