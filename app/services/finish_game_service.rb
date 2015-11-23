class FinishGameService
  def initialize game
    @game = game
  end

  def call
    team1 = @game.teams.first
    team2 = @game.teams.last
    score1, score2 = @game.final_scores
    @game.final_scores = [score1, score2]
    if score1 > score2
      @game.winner = team1
      @game.loser = team2
    else
      @game.winner = team2
      @game.loser = team1
    end
    @game.finished = true
    @game.save

    @game.current_round.destroy if @game.current_round.scores.count == 0
  end
end