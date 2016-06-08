class FinishGameService
  def initialize game, round_params
    @game = game
    @rounds = round_params['rounds']
  end

  def call
    save_rounds
    compute_mprs
    compute_results
  end

  private

  def save_rounds
    @game.rounds.destroy_all
    @game.mprs.destroy_all
    @rounds.values.each do |round|
      scores = (round['scores'] || {}).values.map do |score|
        Score.create points: score['points'], multiplier: score['multiplier']
      end
      @game.rounds.create(
        player_id: round['player_id'],
        team_id: round['team_id'],
        marks: scores.map(&:multiplier).reduce(:+) || 0,
        scores: scores
      )
    end
  end

  def compute_mprs
    @game.players.each do |player|
      @game.mprs.create player: player, mpr: (@game.rounds.where(player: player).average(:marks) || 0.0)
    end
  end

  def compute_results
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
  end
end
