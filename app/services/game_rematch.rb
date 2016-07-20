class GameRematch
  def initialize game
    @game = game
  end

  def call
    new_game = Game.new(teams: @game.teams)
    InitializeGame.new(new_game).call
    new_game
  end
end
