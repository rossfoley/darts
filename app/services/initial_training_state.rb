class InitialTrainingState
  attr_reader :params

  def initialize params
    @params = params
  end

  def call
    {
        game: { training: true },
        teams: teams,
        players: players,
        rounds: rounds,
        playerOrder: player_order_with_team
    }
  end

  def player_order_with_team
    [{player_id: real_player.id, team_id: 1},
     {player_id: bot_json['id'], team_id: 2, bot: true, probabilities: bot_json[:probabilities]}]
  end

  def teams
    [{id: 1, name: real_player.name}, {id: 2, name: bot_json[:name]}]
  end

  def players
    [real_player, bot_json]
  end

  def rounds
    [{
      player_id: real_player.id,
      team_id: 1,
      marks: 0,
      scores: []
    }]
  end

  def bot_json
    @bot_json ||= PlayerBot.new(bot_player).call
  end

  def real_player
    @real_player ||= Player.find(params[:real_player])
  end

  def bot_player
    @bot_player ||= Player.find(params[:bot_player])
  end
end
