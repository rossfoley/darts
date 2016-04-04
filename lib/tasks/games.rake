namespace :games do
  desc 'update MPRs of all games'
  task update_mprs: :environment do
    puts 'Updating MPRs of all games...'
    Game.all.each do |game|
      game.players.each do |player|
          game.mprs.create player: player, mpr: (game.rounds.where(player: player).average(:marks) || 0.0)
      end
    end
    puts 'Updating MPRs completed'
  end
end
