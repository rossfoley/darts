class GameStatisticsService
  def initialize game
    @game = game
  end

  def call
    stats = {}
    multipliers = @game.scores.group_by &:multiplier
    stats[:singles] = multipliers[1].try(:count) || 0
    stats[:doubles] = multipliers[2].try(:count) || 0
    stats[:triples] = multipliers[3].try(:count) || 0
    stats[:teams] = @game.teams.map do |team|
      multipliers = team.scores.where(game: @game).group_by &:multiplier
      {
          singles: multipliers[1].try(:count) || 0,
          doubles: multipliers[2].try(:count) || 0,
          triples: multipliers[3].try(:count) || 0
      }
    end
    stats
  end
end