class Movie < ActiveRecord::Base
  def Movie.get_ratings
    Movie.select(:rating).map(&:rating).uniq.sort
  end
end
