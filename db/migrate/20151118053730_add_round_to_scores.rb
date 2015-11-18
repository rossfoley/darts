class AddRoundToScores < ActiveRecord::Migration
  def change
    add_reference :scores, :round, index: true, foreign_key: true
  end
end
