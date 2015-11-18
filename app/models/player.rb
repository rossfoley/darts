class Player < ActiveRecord::Base
  has_and_belongs_to_many :teams
  has_many :scores
  has_many :rounds

  def average_mpr
    rounds.average(:marks).to_i || 0
  end
end
