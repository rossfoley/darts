class GameStatistics
  include Series

  def initialize game
    @game = game
  end

  def call
    @game.teams.map do |team|
      multipliers = team.game_scores(@game).group_by(&:multiplier)
      {
          name: team.name,
          data: [1, 2, 3].map { |mark| multipliers[mark].try(:count) || 0 }
      }
    end
  end
end