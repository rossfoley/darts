class TeamStatisticsService
  include Series

  def initialize team
    @team = team
  end

  def call
    {
        overall: multiplier_series(@team.scores.group_by &:multiplier),
        players: @team.players.map do |player|
          multiplier_series(player.scores.where(team: @team).group_by(&:multiplier))
        end
    }
  end
end
