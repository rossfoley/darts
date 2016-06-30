class Player < ActiveRecord::Base
  has_and_belongs_to_many :teams, -> { order('teams.id ASC') }
  has_many :rounds, -> { order('rounds.id ASC') }
  has_many :scores, through: :rounds
  has_many :games, through: :teams
  has_many :mprs

  after_initialize :set_default_values

  enum state: {
    active: 10,
    inactive: 20
  }

  RECENT_LIMIT = 25

  scope :with_mprs, -> {
    select('players.*, AVG(mprs.mpr) as average_mpr, AVG(recent_mprs.mpr) as recent_mpr')
    .joins("INNER JOIN mprs ON mprs.player_id = players.id
            INNER JOIN LATERAL (
              SELECT mprs.*
              FROM mprs
              WHERE mprs.player_id = players.id
              ORDER BY mprs.id DESC
              LIMIT #{RECENT_LIMIT}
            ) recent_mprs ON true")
    .group('players.id')
  }

  def adjusted_average_mpr
    (rounds.where('marks > 0').average(:marks) || 0.0).round(2)
  end

  def recent_computed_mpr
    recent_game_ids = games.reorder('games.created_at DESC').limit(RECENT_LIMIT).pluck(:id)
    (mprs.where(game_id: recent_game_ids).average(:mpr) || 0.0).round(2)
  end

  def highest_mpr
    (mprs.maximum(:mpr) || 0.0).round(2)
  end

  def win_percent
    return 0.0 if games.count == 0
    (games.where(winner_id: teams).count * 100.0 / games.count).round(2)
  end

  def recent_win_percent
    return 0.0 if games.count == 0
    recent_games = games.limit(RECENT_LIMIT).reorder('games.created_at DESC').to_a
    recent_wins = recent_games.select { |game| game.winner_id.in? teams.map(&:id) }
    (recent_wins.size * 100.0 / recent_games.size).round(2)
  end

  def team_for_game game
    teams.joins(:games).where(games: {id: game.id}).first
  end

  private

  def set_default_values
    self.state ||= :active
  end
end
