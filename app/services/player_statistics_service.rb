class PlayerStatisticsService
  include Series

  def initialize player
    @player = player
  end

  def call
    {
        multipliers: multiplier_series(@player.scores.group_by &:multiplier),
        points: points_series(@player.scores.group_by &:points)
    }
  end
end
