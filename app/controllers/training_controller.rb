class TrainingController < ApplicationController
  def new
    @game = Game.new.decorate
  end

  def play
    @initial_state = InitialTrainingState.new(game_params).call
  end

  private

  def game_params
    params.require(:training_game).permit(:real_player, :bot_player)
  end
end
