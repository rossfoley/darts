class Game < ActiveRecord::Base
  has_and_belongs_to_many :teams, -> { order('teams.id ASC') }
  has_many :rounds, -> { order('rounds.id ASC') }, dependent: :destroy
  has_many :scores, through: :rounds
  has_many :players, through: :teams
  has_many :mprs, dependent: :destroy

  serialize :final_scores, Array
  serialize :player_order, Array

  validates :teams, length: {is: 2}

  def team_scores
    teams.map { |team| team.total_scores(self) }
  end

  def final_scores
    if finished
      super
    else
      teams.map { |team| team.final_score self }
    end
  end

  def ordered_players
    player_order.map do |ordered_id|
      players.find { |p| p.id == ordered_id }
    end
  end

  def next_player
    index = player_order.index current_round.player.id
    player_order[(index + 1) % player_order.size]
  end

  def current_round
    rounds.last
  end

  def winner
    if finished
      Team.find(winner_id)
    else
      nil
    end
  end

  def winner= team
    self.winner_id = team.id
  end

  def loser
    if finished
      Team.find(loser_id)
    else
      nil
    end
  end

  def loser= team
    self.loser_id = team.id
  end
end
