class Game < ActiveRecord::Base
  has_and_belongs_to_many :teams, -> { order('teams.id ASC') }
  has_many :rounds, -> { order('rounds.id ASC') }, dependent: :destroy
  has_many :scores, through: :rounds

  serialize :final_scores, Array

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

  # Array of players indicating play order
  # Assumes that the teams have the same number of players
  def player_order
    team_size = teams.first.players.count
    (0...team_size).flat_map do |index|
      [teams.first.players[index], teams.last.players[index]]
    end
  end

  def next_player
    current_order = player_order
    current_player = current_round.player
    index = current_order.index current_player
    current_order[(index + 1) % current_order.size].id
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
