class RemoveScoreForeignKeys < ActiveRecord::Migration
  def change
    remove_column :scores, :game_id
    remove_column :scores, :team_id
    remove_column :scores, :player_id
  end
end
