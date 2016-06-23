class LeaderboardsController < ApplicationController
  def players
    @players = Player.all
                     .joins(:mprs)
                     .select('players.id, players.name, avg(mprs.mpr) as average_computed_mpr')
                     .group('players.id')
                     .sort_by(&:recent_mpr)
                     .reverse
  end

  def all_time
    @players = Player.all
                     .joins(:mprs)
                     .select('players.id, players.name, avg(mprs.mpr) as average_computed_mpr')
                     .group('players.id')
                     .order('average_computed_mpr DESC')
  end

  def teams
    @teams = Team.all
                 .includes(:games, players: :mprs)
                 .sort_by(&:recent_mpr)
                 .reverse
  end
end
