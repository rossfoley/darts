class LeaderboardsController < ApplicationController
  def players
    @players = Player.active
                     .joins(:mprs)
                     .select('players.*, avg(mprs.mpr) as average_computed_mpr')
                     .group('players.id')
                     .sort_by(&:recent_mpr)
                     .reverse
  end

  def all_time
    @players = Player.active
                     .joins(:mprs)
                     .select('players.*, avg(mprs.mpr) as average_computed_mpr')
                     .group('players.id')
                     .order('average_computed_mpr DESC')
  end

  def teams
    @teams = Team.active
                 .includes(:games, players: :mprs)
                 .sort_by(&:recent_mpr)
                 .reverse
  end
end
