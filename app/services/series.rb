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
end
