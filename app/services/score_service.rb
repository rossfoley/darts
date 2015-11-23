class ScoreService
  def initialize game, params
    @game = game
    @params = params
  end

  def call
    # Basic attributes
    team = Team.find(@params[:team])
    player = Player.find(@params[:player])
    points = @params[:points].to_i
    multiplier = @params[:multiplier].to_i

    # Round logic
    round = @game.current_round
    return unless round.player == player

    # Current scores
    scores = @game.team_scores
    team_score = scores.delete_at(@game.teams.index(team))[points]
    other_score = scores.delete_at(0)[points]

    # Limit the multiplier if the enemy team already closed this point
    if other_score[:closed]
      return if team_score[:closed]
      multiplier = [multiplier, 3 - team_score[:total]].min
    end

    # Update Round
    round.marks += multiplier
    round.scores.create(points: points, multiplier: multiplier)
    round.save

    # Automatically advance to next round
    NextRoundService.new(@game).call if round.scores.count >= 3
  end
end