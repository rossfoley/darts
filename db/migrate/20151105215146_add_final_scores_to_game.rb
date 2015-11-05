class AddFinalScoresToGame < ActiveRecord::Migration
  def change
    add_column :games, :final_scores, :text
  end
end
