module GamesHelper
  def points_to_symbol points
    case points
      when 0 then ''
      when 1 then '\\'
      when 2 then 'X'
      else
        output = '&#9421;'
        output += '<span class="tally">| | | |</span>' * ((points - 3) / 5)
        output += ' |' * ((points - 3) % 5)
        output.html_safe
    end
  end

  def both_closed scores, target
    if scores[0][target][:closed] and scores[1][target][:closed]
      'both-closed'
    else
      ''
    end
  end

  def closed scores, target, team
    if scores[team][target][:closed]
      'closed'
    else
      ''
    end
  end

  def active_player_class player, active_player
    if player.id == active_player.id
      'active-player'
    else
      ''
    end
  end
end
