class GameStatisticsService
  include Series

  def initialize game
    @game = game
  end

  def call
    {
        overall: multiplier_series(@game.scores.group_by &:multiplier),
        teams: @game.teams.map do |team|
          multiplier_series(team.scores.where(game: @game).group_by(&:multiplier))
        end
    }
  end
end