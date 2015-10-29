class ScoreServices
  def initialize game
    @game = game
  end

  def submit_scores params
    if params[:points].to_i > 0
      Score.create(
        points: params[:points].to_i,
        multiplier: params[:multiplier].to_i,
        game: @game,
        player_id: params[:player_id].to_i,
        team_id: params[:team_id].to_i
      )
    end
  end
end