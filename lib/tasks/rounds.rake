namespace :rounds do
  desc 'update marks of all rounds'
  task update_marks: :environment do
    puts 'Updating marks of all rounds...'
    Round.all.each do |round|
      marks = round.scores.sum(:multiplier)
      round.update marks: marks
    end
    puts 'Updating marks completed'
  end
end
