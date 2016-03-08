class UndoScoreService
  def initialize game
    @game = game
  end

  def call
    return if @game.rounds.count == 1 and @game.rounds.last.scores.count == 0
    @game.rounds.last.destroy if @game.rounds.last.scores.count == 0
    return if @game.rounds.count == 1 and @game.rounds.last.scores.count == 0
    last_score = @game.scores.last
    @game.rounds.last.update marks: (@game.rounds.last.marks - last_score.multiplier)
    last_score.destroy
  end
end
