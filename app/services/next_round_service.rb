class NextRoundService
  def initialize game
    @game = game
  end

  def call
    next_player = Player.find(@game.next_player)
    next_team = next_player.teams.joins(:games).where(games: {id: @game.id}).first
    @game.rounds.create(player: next_player, team: next_team)
  end
end