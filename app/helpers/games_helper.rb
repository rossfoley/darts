module GamesHelper
  def points_to_symbol points
    case points
      when 0 then ''
      when 1 then '\\'
      when 2 then 'X'
      else ('&#9421;' + ' |' * (points - 3)).html_safe
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
end
