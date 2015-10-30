class Team < ActiveRecord::Base
  has_and_belongs_to_many :players
  has_and_belongs_to_many :games
  has_many :scores

  def total_scores game
    groups = scores.where(game: game).group_by(&:points)
    score_totals = Score.cricket_points.map do |points|
      total = 0
      closed = false
      if groups[points]
        total = groups[points].inject(0) {|sum, s| sum + s.multiplier}
        closed = total >= 3
      end
      [points, {total: total, closed: closed}]
    end
    Hash[score_totals]
  end
end
