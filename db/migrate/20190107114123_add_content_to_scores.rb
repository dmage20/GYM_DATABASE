class AddContentToScores < ActiveRecord::Migration[5.2]
  def change
    add_column :scores, :content, :text
  end
end
