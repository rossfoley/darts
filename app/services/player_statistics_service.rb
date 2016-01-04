class PlayerStatisticsService
  include Series
  HISTORY_LIMIT = 10

  def initialize player
    @player = player
  end

  def call
    {
        multipliers: multiplier_series(@player.scores.group_by &:multiplier),
        points: points_series(@player.scores.group_by &:points),
        history: history,
        mpr_history: mpr_history
    }
  end

  def history
    games = Game.joins(teams: :players)
                .where(players: {id: @player.id})
                .reorder(created_at: :desc)
                .limit(HISTORY_LIMIT)
    scores = games.map do |game|
      team = game.teams.where(id: @player.teams).first
      game.final_scores[game.teams.index(team)] || 0
    end
    dates = games.map { |game| game.created_at.strftime '%d/%m/%y' }
    { x: dates.reverse, y: scores.reverse }
  end

  def mpr_history
    games = @player.games
                   .joins(:rounds)
                   .select('games.created_at, AVG(rounds.marks) as mpr')
                   .group('games.id, teams.id')
                   .limit(HISTORY_LIMIT)
    mprs = games.map(&:mpr).map {|mpr| mpr.try(:round, 2) || 0.0}
    dates = games.map { |game| game.created_at.strftime '%d/%m/%y' }
    { x: dates, y: mprs }
  end
end
