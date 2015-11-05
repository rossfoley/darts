module Series
  def multiplier_series multipliers
    [
        {
            name: 'Singles',
            y: multipliers[1].try(:count) || 0
        },
        {
            name: 'Doubles',
            y: multipliers[2].try(:count) || 0
        },
        {
            name: 'Triples',
            y: multipliers[3].try(:count) || 0
        }
    ]
  end

  def points_series points
    Score.cricket_points.map do |point|
      {
          name: Score.points_name(point),
          y: points[point].try(:count) || 0
      }
    end
  end
end
