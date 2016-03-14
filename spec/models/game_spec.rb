require 'rails_helper'

describe Game do
  context 'validations' do
    describe 'teams' do
      let(:teams) { [create(:team), create(:team), create(:team)] }
      let(:one_team_game) { build :game, teams: [teams[0]] }
      let(:three_team_game) { build :game, teams: teams }

      it 'must contain 2 teams' do
        expect(one_team_game).not_to be_valid
        expect(three_team_game).not_to be_valid
      end
    end
  end

  context 'finished games' do
    describe 'winner and loser' do
      let(:game) { create :game, finished: false }

      it 'returns nil if the game is not finished' do
        expect(game.winner).to be_nil
        expect(game.loser).to be_nil
      end

      it 'sets the corresponding id field' do
        game.finished = true
        game.winner = game.teams.first
        game.loser = game.teams.last

        expect(game.winner_id).to eq game.teams.first.id
        expect(game.loser_id).to eq game.teams.last.id
      end
    end

    describe :final_scores do
      let(:game) { create :game, final_scores: [20, 25], finished: false }

      it 'recalculates score for unfinished games' do
        expect(game.final_scores).to eq [0, 0]
      end

      it 'uses the cached score for finished games' do
        game.finished = true
        expect(game.final_scores).to eq [20, 25]
      end
    end
  end

  context 'player order' do
    let(:player1) { create :player }
    let(:player2) { create :player }

    let(:team1) { create :team, players: [player1] }
    let(:team2) { create :team, players: [player2] }

    let(:current_round) { create :round, player: player1, team: team1 }

    let(:game) { create :game,
                        teams: [team1, team2],
                        rounds: [current_round],
                        player_order: [player1.id, player2.id] }

    describe :ordered_players do
      it 'returns an ordered array of players' do
        game.player_order = [player2.id, player1.id]
        expect(game.ordered_players).to eq [player2, player1]
      end
    end

    describe :current_round do
      it 'returns the latest round in the game' do
        new_round = create :round, player: player2, team: team2
        game.rounds << new_round

        expect(game.current_round).to eq new_round
      end
    end

    describe :next_player do
      it 'returns the next player in the player_order array' do
        expect(game.next_player).to eq player2.id
      end

      it 'goes back to the start after the last player' do
        game.rounds << create(:round, player: player2, team: team2)
        expect(game.next_player).to eq player1.id
      end
    end
  end
end
