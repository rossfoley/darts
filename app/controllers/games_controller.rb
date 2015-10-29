class GamesController < ApplicationController
  before_action :set_game, only: [:show, :play, :submit_scores, :submit_score, :edit, :update, :destroy]

  def index
    @games = Game.all.decorate
  end

  def show
  end

  def play
    @scores = @game.team_scores
    @totals = @game.total_scores
  end

  def submit_scores
    ScoreServices.new(@game).submit_scores(score_params)
    redirect_to play_game_path(@game), notice: 'Scores saved'
  end

  def submit_score
    team = @game.teams[params[:team].to_i]
    player = team.players[0]
    Score.create(
      game: @game,
      player: player,
      team: team,
      points: params[:points].to_i,
      multiplier: params[:multiplier].to_i
    )
    redirect_to play_game_path(@game)
  end

  def new
    @game = Game.new.decorate
  end

  def edit
  end

  def create
    @game = Game.new(game_params).decorate

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id]).decorate
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:winner_id, :loser_id, :finished, team_ids: [])
    end

    def score_params
      params.require(:score).permit(:player_id, :team_id, :points, :multiplier)
    end
end
