require 'rails_helper'

describe Team do
  let(:player1) { create :player }
  let(:player2) { create :player }

  let(:team1) { create :team, players: [player1] }
  let(:team2) { create :team, players: [player2] }

  let(:current_round) { create :round, player: player1, team: team1 }

  let(:game) { create :game,
                      teams: [team1, team2],
                      rounds: [current_round],
                      player_order: [player1.id, player2.id] }

  describe :game_scores do
    it 'returns a list of scores for the specified game' do
      score = create :score, points: 20, multiplier: 3, round: current_round
      expect(team1.game_scores game).to eq [score]
    end
  end

  context 'scoring' do
    before :each do
      current_round.scores = [
          create(:score, points: 20, multiplier: 3),
          create(:score, points: 20, multiplier: 2),
          create(:score, points: 18, multiplier: 2)
      ]
    end

    describe :final_score do
      it 'computes the final score based on Cricket rules' do
        expect(team1.final_score game).to eq 40
      end
    end

    describe :total_scores do
      before :each do
        @result = team1.total_scores game
      end

      it 'correctly computes information for closed points' do
        expect(@result[20][:total]).to eq 5
        expect(@result[20][:closed]).to eq true
      end

      it 'correctly computes information for open points' do
        expect(@result[18][:total]).to eq 2
        expect(@result[18][:closed]).to eq false
      end

      it 'correctly handles points with no scores' do
        expect(@result[16][:total]).to eq 0
        expect(@result[16][:closed]).to eq false
      end
    end
  end
end
