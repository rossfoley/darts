class GameStatisticsService
  def initialize game
    @game = game
  end

  def call
    stats = {}
    multipliers = @game.scores.group_by &:multiplier
    stats[:overall] = [
        {
            name: 'Singles',
            y: multipliers[1].try(:count) || 0
        },
        {
            name: 'Doubles',
            y: multipliers[2].try(:count) || 0
        },
        {
            name: 'Triples',
            y: multipliers[3].try(:count) || 0
        }
    ]
    stats[:teams] = @game.teams.map do |team|
      multipliers = team.scores.where(game: @game).group_by &:multiplier
      [
          {
              name: 'Singles',
              y: multipliers[1].try(:count) || 0
          },
          {
              name: 'Doubles',
              y: multipliers[2].try(:count) || 0
          },
          {
              name: 'Triples',
              y: multipliers[3].try(:count) || 0
          }
      ]
    end
    stats
  end
end