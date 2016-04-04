class LeaderboardsController < ApplicationController
  def players
    @players = Player.all
                     .joins(:mprs)
                     .select('players.id, players.name, avg(mprs.mpr) as average_computed_mpr')
                     .group('players.id')
                     .sort_by(&:recent_mpr)
                     .reverse
  end
end
