class Score < ActiveRecord::Base
  belongs_to :round

  def self.cricket_points
    [20, 19, 18, 17, 16, 15, 25]
  end

  def self.multiplier_values
    [1, 2, 3]
  end

  def self.points_name points
    if points == 25
      'Bull'
    else
      points.to_s
    end
  end
end
