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
    scores = object.final_scores.sort.reverse
    "#{scores.first} - #{scores.last}"
  end
end
