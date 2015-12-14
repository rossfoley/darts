class Team < ActiveRecord::Base
  has_and_belongs_to_many :players, -> { order('id ASC') }
  has_and_belongs_to_many :games, -> { order('id ASC') }
  has_many :rounds, -> { order('id ASC') }
  has_many :scores, through: :rounds

  def game_scores game
    scores.joins(round: :game).where('games.id = ?', game.id)
  end

  def total_scores game
    groups = game_scores(game).group_by(&:points)
    score_totals = Score.cricket_points.map do |points|
      total = 0
      closed = false
      if groups[points]
        total = groups[points].inject(0) { |sum, s| sum + s.multiplier }
        closed = total >= 3
      end
      [points, {total: total, closed: closed}]
    end
    Hash[score_totals]
  end

  def final_score game
    sum = 0
    total_scores(game).each do |points, info|
      if info[:closed]
        sum += points * (info[:total] - 3)
      end
    end
    sum
  end

  def name_with_players
    "#{name} - #{players.map(&:name).join(', ')}"
  end
end
