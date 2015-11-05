class GamesController < ApplicationController
  before_action :set_game, except: [:index, :new, :create]

  def index
    @games = Game.all.decorate
  end

  def show
    @scores = @game.team_scores
    @totals = @game.final_scores
    @stats = GameStatisticsService.new(@game).call
  end

  def play
    @scores = @game.team_scores
    @totals = @game.final_scores
  end

  def submit_score
    ScoreService.new(@game, params).call
    redirect_to play_game_path(@game)
  end

  def undo
    @game.scores.last.destroy
    redirect_to play_game_path(@game)
  end

  def finish
    FinishGameService.new(@game).call
    redirect_to game_path(@game)
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
        format.html { redirect_to play_game_path(@game), notice: 'Game was successfully created.' }
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
