class GamePlayerMprService

  def initialize game
    @game = game
  end

  def call
    mprs = {}
    @game.teams.each do |team|
      team.players.each do |player|
        mprs[player.name] = (@game.rounds.where(player: player).average(:marks) || 0.0).round(2)
      end
    end
    mprs
  end
end