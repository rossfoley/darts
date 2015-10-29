class Game < ActiveRecord::Base
  has_and_belongs_to_many :teams
  has_many :scores

  validates :teams, length: {is: 2}

  def team_scores
    teams.includes(:scores).map {|team| team.total_scores(self) }
  end

  def total_scores
    team_scores.map do |team|
      team.values[:total].reduce(:+)
    end
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
