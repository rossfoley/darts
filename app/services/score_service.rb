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

    # Current scores
    scores = @game.team_scores
    team_score = scores.delete_at(@game.teams.index(team))[points]
    other_score = scores.delete_at(0)[points]

    # Limit the multiplier if the enemy team already closed this point
    if other_score[:closed]
      return if team_score[:closed]
      multiplier = [multiplier, 3 - team_score[:total]].min
    end

    Score.create(
        game: @game,
        player: player,
        team: team,
        points: points,
        multiplier: multiplier
    )
  end
end