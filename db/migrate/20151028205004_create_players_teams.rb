class CreatePlayersTeams < ActiveRecord::Migration
  def change
    create_table :players_teams, :id => false do |t|
      t.references :player, :team
    end

    add_index :players_teams, [:player_id, :team_id],
      name: "players_teams_index",
      unique: true
  end
end
