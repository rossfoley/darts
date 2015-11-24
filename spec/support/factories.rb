FactoryGirl.define do
  factory :game do
    teams {[create(:team), create(:team)]}
    winner_id
    loser_id
    finished false
    final_scores
  end

  factory :team do
    players {[create(:player)]}
    name 'TestTeam'
  end

  factory :player do
    name 'PlayerName'
  end

  factory :round do
    marks 0
    player
    team
    game
  end

  factory :score do
    multiplier 1
    points 15
    round
  end
end