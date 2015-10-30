class FinishGameService
  def initialize game
    @game = game
  end

  def call
    @game.finished = true
    team1 = @game.teams.first
    team2 = @game.teams.last
    score1 = team1.final_score @game
    score2 = team2.final_score @game
    if score1 > score2
      @game.winner = team1
      @game.loser = team2
    else
      @game.winner = team2
      @game.loser = team1
    end
    @game.save
  end
end