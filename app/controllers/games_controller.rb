require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = (0...rand(5..10)).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    # binding.pry
    answer = params[:answer].strip
    grid = params[:grid]
    return @result = { score: 0, message: "not in the grid", grid: grid } unless in_grid?(answer, grid.split(''))

    query = JSON.parse(open('https://wagon-dictionary.herokuapp.com/' + answer).read)
    if query['found']
      @result = { answer: answer, score: answer.size, message: "well done", grid: grid }
    else
      @result = { answer: answer, score: 0, message: "not an english word", grid: grid }
    end
  end

  def in_grid?(answer, grid)
    answer.upcase.split('').each do |letter|
      return false unless grid.include?(letter)

      grid.delete_at(grid.index(letter))
    end
    true
  end
end
