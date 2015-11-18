class LeaderboardsController < ApplicationController
  def players
    @players = Player.all
                   .joins(:rounds)
                   .select('players.id, players.name, avg(rounds.marks) as mpr')
                   .group('players.id')
                   .order('mpr DESC')
  end
end