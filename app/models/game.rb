class Game < ActiveRecord::Base
  has_and_belongs_to_many :teams

  validates :teams, length: {is: 2}

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
