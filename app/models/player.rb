class Player < ActiveRecord::Base
  has_and_belongs_to_many :teams
  has_many :scores
  has_many :rounds

  def average_mpr
    (rounds.average(:marks) || 0.0).round(2)
  end

  def highest_mpr
    max = games.map { |game| game.rounds.where(player: self).average(:marks) || 0.0 }.max
    max.round(2)
  end

  def games
    Game.joins("join games_teams on games.id = games_teams.game_id").where(games_teams: {team_id: teams})
  end

  def win_percent
    return 0.0 if games.count == 0
    games.where(winner_id: teams).count * 100.0 / games.count
  end
end
