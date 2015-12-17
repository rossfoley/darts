class Player < ActiveRecord::Base
  has_and_belongs_to_many :teams, -> { order('teams.id ASC') }
  has_many :rounds, -> { order('rounds.id ASC') }
  has_many :scores, through: :rounds
  has_many :games, through: :teams

  RECENT_LIMIT = 25

  def average_mpr
    (rounds.average(:marks) || 0.0).round(2)
  end

  def adjusted_average_mpr
    (rounds.where('marks > 0').average(:marks) || 0.0).round(2)
  end

  def recent_mpr
    recent_games = games.reorder(created_at: :desc).limit(RECENT_LIMIT).pluck('games.id')
    (rounds.where(game: recent_games).average(:marks) || 0.0).round(2)
  end

  def highest_mpr
    max = games.map { |game| game.rounds.where(player: self).average(:marks) || 0.0 }.max
    (max || 0.0).round(2)
  end

  def win_percent
    return 0.0 if games.count == 0
    (games.where(winner_id: teams).count * 100.0 / games.count).round(2)
  end

  def team_for_game game
    teams.joins(:games).where(games: {id: game.id}).first
  end
end
