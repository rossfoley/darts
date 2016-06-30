class LeaderboardsController < ApplicationController
  def players
    @players = Player.active.with_mprs.order('recent_mpr DESC')
  end

  def all_time
    @players = Player.active.with_mprs.order('average_mpr DESC')
  end

  def teams
    @teams = Team.active
                 .includes(:games, players: :mprs)
                 .sort_by(&:recent_mpr)
                 .reverse
  end
end
