class PlayerBot
  attr_reader :player, :random

  def initialize player
    @player = Player.with_mprs.includes(rounds: :scores).find_by id: player.id
    @random = Random.new(Time.zone.now.to_i)
  end

  def call
    player.as_json.merge(
      name: "#{player.name} Bot",
      bot: true,
      probabilities: {
        hit: hit_probability,
        points: point_probabilities
      }
    )
  end

  def round
    throws = Array.new(3).map { random_throw }
    throws.each do |dart_throw|
      if dart_throw.present?
        puts "#{%w(Single Double Triple)[dart_throw[1] - 1]} #{dart_throw[0]}"
      else
        puts 'Miss'
      end
    end
    throws
  end

  private

  def random_throw
    if random.rand <= hit_probability
      hit = random.rand(point_probabilities.values.sum)
      point_probabilities.each do |points, probability|
        return points if hit < probability
        hit -= probability
      end
    end
  end

  def point_probabilities
    @point_probabilities ||= player.scores.group_by(&:points).map do |point, scores|
      scores.group_by(&:multiplier).map { |mark, mark_scores| [[point, mark], mark_scores.size] }
    end.flatten(1).to_h
  end

  def hit_probability
    return @hit_probability if @hit_probability.present?
    scores = player.rounds.map(&:scores).map(&:size)
    @hit_probability = scores.sum.to_f / (scores.count * 3)
  end
end
