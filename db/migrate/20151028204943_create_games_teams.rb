class CreateGamesTeams < ActiveRecord::Migration
  def change
    create_table :games_teams, :id => false do |t|
      t.references :game, :team
    end

    add_index :games_teams, [:game_id, :team_id],
      name: "games_teams_index",
      unique: true
  end
end
