class InitialState
  def initialize game
    @game = game
  end

  def call
    {
        game: @game,
        teams: @game.teams,
        players: @game.ordered_players,
        rounds: @game.rounds.as_json(include: :scores),
        playerOrder: player_order_with_team
    }
  end

  def player_order_with_team
    @game.ordered_players.map do |player|
      {player_id: player.id, team_id: player.team_for_game(@game).id}
    end
  end
end
