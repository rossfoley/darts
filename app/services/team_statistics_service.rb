class TeamStatisticsService
  include Series

  def initialize team
    @team = team
  end

  def call
    {
        overall: multiplier_series(@team.scores.group_by &:multiplier),
        history: history,
        players: @team.players.map do |player|
          multiplier_series(player.scores.joins(round: :team).where('teams.id = ?', @team).group_by(&:multiplier))
        end
    }
  end

  private

  def history
    scores = @team.games.includes(:teams).map do |game|
      game.final_scores[game.teams.index(@team)] || 0
    end
    dates = @team.games.includes(:teams).map {|game| game.created_at.strftime '%d/%m/%y'}
    {
        x: dates,
        y: scores
    }
  end
end
