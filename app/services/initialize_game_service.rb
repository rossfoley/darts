class InitializeGameService
  def initialize game
    @game = game
  end

  def call
    @game.player_order = random_player_order @game
    @game.save

    first_player = Player.find(@game.player_order.first)
    first_team = first_player.teams.joins(:games).where(games: {id: @game.id}).first
    @game.rounds.create(player: first_player, team: first_team)
  end

  private

  def random_player_order game
    players = game.teams.map { |team| team.players.pluck(:id).shuffle }
    players.first.zip(players.last).shuffle.flatten.compact
  end
end
