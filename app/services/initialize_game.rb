class InitializeGame
  def initialize game
    @game = game
  end

  def call
    @game.player_order = random_player_order @game
    @game.save

    first_player = Player.find(@game.player_order.first)
    first_team = first_player.team_for_game @game
    @game.rounds.create(player: first_player, team: first_team)
  end

  private

  def random_player_order game
    first_team, second_team = game.teams.map { |team| team.players.pluck(:id).shuffle }
    first_team.zip(second_team).shuffle.flatten.compact
  end
end
