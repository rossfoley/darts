class GamesController < ApplicationController
  before_action :set_game, except: [:index, :new, :create]

  def index
    @games = Game.includes(:teams).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    redirect_to games_path unless @game.finished
    @scores = @game.team_scores
    @totals = @game.final_scores
    @stats = GameStatisticsService.new(@game).call
  end

  def play
    redirect_to game_path(@game) if @game.finished
    @game = Game.includes(teams:{players: {rounds: :scores}}).find(params[:id]).decorate
    @initial_state = InitialStateService.new(@game).call
  end

  def finish
    FinishGameService.new(@game, round_params).call
    render json: {redirectUrl: game_url(@game)}
  end

  def new
    @game = Game.new.decorate
  end

  def edit
  end

  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        InitializeGameService.new(@game).call
        format.html { redirect_to play_game_path(@game) }
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

  def set_game
    @game = Game.find(params[:id]).decorate
  end

  def game_params
    params.require(:game).permit(:winner_id, :loser_id, :finished, team_ids: [])
  end

  def round_params
    params.require(:game).permit(rounds: [:player_id, :team_id, scores: [:points, :multiplier]])
  end
end
