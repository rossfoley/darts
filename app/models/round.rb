class Round < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  belongs_to :team
  has_many :scores
end
