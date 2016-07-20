class InitializeSuggestedGame
  attr_accessor :params

  def initialize params
    @params = params
  end

  def call
    players = params[:player_ids].map { |id| Player.with_mprs.includes(:mprs, teams: :players).find_by id: id }.compact

    # Teams must have the same number of players
    if players.size % 2 != 0
      game = Game.new
      game.errors.add :players, 'There must be an even number of players'
      return game
    end

    teams = players.combination(players.size / 2).to_a.map do |player_group|
      [player_group, players - player_group]
    end.min_by do |combination|
      (combination[0].map(&:recent_mpr).reduce(:+) - combination[1].map(&:recent_mpr).reduce(:+)).abs
    end.map do |team_players|
      team = team_players.map(&:teams).map do |teams|
        teams.select { |t| t.players.count == team_players.size }
      end.reduce(:&).first
      if team.blank?
        name = team_players.map(&:name).map {|name| name.split ' '}.map(&:last).join ' '
        team = Team.create(name: name, players: team_players)
      end
      team
    end

    Game.create(teams: teams).tap { |g| InitializeGame.new(g).call }
  end
end
