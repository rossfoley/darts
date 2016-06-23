class Team < ActiveRecord::Base
  has_and_belongs_to_many :players, -> { order('players.id ASC') }
  has_and_belongs_to_many :games, -> { order('games.id ASC') }
  has_many :rounds, -> { order('rounds.id ASC') }
  has_many :scores, through: :rounds

  def game_scores game
    scores.joins(round: :game).where('games.id = ?', game.id)
  end

  def total_scores game
    groups = game_scores(game).group_by(&:points)
    Score.cricket_points.map do |points|
      groups[points] ||= []
      total = groups[points].inject(0) { |sum, s| sum + s.multiplier }
      closed = total >= 3
      [points, {total: total, closed: closed}]
    end.to_h
  end

  def final_score game
    total_scores(game).reduce(0) do |sum, (points, info)|
      sum + points * [info[:total] - 3, 0].max
    end
  end

  def win_percent
    return 0.0 if games.count == 0
    (games.where(winner_id: id).count * 100.0 / games.count).round(2)
  end

  def recent_mpr
    player_mprs = players.map(&:recent_mpr)
    (player_mprs.reduce(:+) / player_mprs.size).round(2)
  end

  def name_with_players
    "#{name} - #{players.map(&:name).join(', ')}"
  end
end
