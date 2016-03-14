FactoryGirl.define do
  factory :game do
    teams {[create(:team), create(:team)]}
    winner_id { teams.first.id }
    loser_id { teams.last.id }
    finished false
    final_scores [0, 0]
    player_order []
  end

  factory :player do
    sequence(:name) {|n| "Player #{n}"}
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

  factory :team do
    players {[create(:player)]}
    sequence(:name) {|n| "Team #{n}"}
  end

  factory :user do
    sequence(:uid) {|n| "UID#{n}"}
    sequence(:email) {|n| "test#{n}@example.com"}
  end
end
