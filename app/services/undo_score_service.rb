class UndoScoreService
  def initialize game
    @game = game
  end

  def call
    return if @game.rounds.count == 1 and @game.rounds.last.scores.count == 0
    @game.rounds.last.destroy if @game.rounds.last.scores.count == 0
    @game.scores.last.destroy
  end
end