class GamesController < ApplicationController
  before_action :set_game, except: [:index, :new, :create]

  def index
    @games = Game.all.order(created_at: :desc).decorate
  end

  def show
    @scores = @game.team_scores
    @totals = @game.final_scores
    @stats = GameStatisticsService.new(@game).call
    @empty_rounds = (@game.rounds.where(marks: 0).count * 100.0 / @game.rounds.count).round
    @player_mprs = GamePlayerMprService.new(@game).call
  end

  def play
    @scores = @game.team_scores
    @totals = @game.final_scores
    @active_player = @game.rounds.last.player
  end

  def submit_score
    ScoreService.new(@game, params).call
    redirect_to play_game_path(@game)
  end

  def undo_score
    UndoScoreService.new(@game).call
    redirect_to play_game_path(@game)
  end

  def undo_round
    @game.rounds.last.destroy if @game.rounds.count > 1
    redirect_to play_game_path(@game)
  end

  def finish
    FinishGameService.new(@game).call
    redirect_to game_path(@game)
  end

  def new_round
    @game.rounds.create(player_id: params[:player], team_id: params[:team])
    redirect_to play_game_path(@game)
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
        @game.rounds.create(player: @game.teams.first.players.first, team: @game.teams.first)
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
