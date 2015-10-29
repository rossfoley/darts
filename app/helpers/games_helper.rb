module GamesHelper
  def points_to_symbol points
    case points
      when 0 then ''
      when 1 then '\\'
      when 2 then 'X'
      else ('&#9421;' + ' |' * (points - 3) + " (#{points - 3})").html_safe
    end
  end
end
