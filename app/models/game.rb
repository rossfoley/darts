class Game < ActiveRecord::Base
  has_and_belongs_to_many :teams

  def winner
    Team.find(winner_id)
  end

  def winner= team
    winner_id = team.id
  end

  def loser
    Team.find(loser_id)
  end

  def loser= team
    loser_id = team.id
  end
end
