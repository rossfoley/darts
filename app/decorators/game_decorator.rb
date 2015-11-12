class GameDecorator < Draper::Decorator
  delegate_all

  def winner_name
    if object.finished
      winner.name
    else
      ''
    end
  end

  def loser_name
    if object.finished
      loser.name
    else
      ''
    end
  end

  def start_date
    object.created_at.strftime("%b %-d, %Y")
  end

  def final_score
    "#{object.final_scores[0]} - #{object.final_scores[1]}"
  end
end
