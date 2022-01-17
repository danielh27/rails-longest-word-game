require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    letters = ('A'..'Z').to_a
    @grid = []
    10.times do
      @grid << letters.sample
    end
  end

  def valid_word?(word, grid)
    chars = word.upcase.chars
    chars.all? do |char|
      grid.include?(char) && chars.count(char) <= grid.count(char)
    end
  end

  def score
    word = params[:word]
    grid = params[:grid].split(' ')
    @score = session[:score] || 0

    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    result = JSON.parse(URI.open(url).read)

    @valid = result['found'] && valid_word?(word, grid)
    @data = result

    session[:score] = @score + result['length'] * 5 if @valid
  end
end
