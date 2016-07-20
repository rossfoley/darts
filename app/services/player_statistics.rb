class PlayerStatistics
  include Series
  HISTORY_LIMIT = 30

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
    scores = games.includes(:teams).map do |game|
      team = game.teams.where(id: @player.teams).first
      game.final_scores[game.teams.index(team)] || 0
    end
    dates = games.map { |game| game.created_at.strftime '%d/%m/%y' }
    { x: dates.reverse, y: scores.reverse }
  end

  def mpr_history
    game_mprs = @player.mprs
                       .includes(:game)
                       .order('games.created_at DESC')
                       .limit(HISTORY_LIMIT)
    player_mprs = game_mprs.map(&:mpr).map {|mpr| mpr.try(:round, 2) || 0.0}
    dates = game_mprs.map { |mpr| mpr.game.created_at.strftime '%d/%m/%y' }
    { x: dates.reverse, y: player_mprs.reverse }
  end
end
