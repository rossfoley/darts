class PlayerStatisticsService
  include Series

  def initialize player
    @player = player
  end

  def call
    {
        multipliers: multiplier_series(@player.scores.group_by &:multiplier),
        points: points_series(@player.scores.group_by &:points),
        history: history
    }
  end

  def history
    Game.joins(teams: :players).where(players: {id: @player.id}).map do |game|
      team = game.teams.where(id: @player.teams).first
      game.final_scores[game.teams.index(team)] || 0
    end
  end
end
