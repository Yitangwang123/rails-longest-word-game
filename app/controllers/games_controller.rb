require 'open-uri'
require 'json'
class GamesController < ApplicationController
  def new
    @start = Time.now
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @word = params[:word]
    @grid = params[:grid].split(' ')
    @start = params[:start].to_time
    @new_word = @word.upcase.split('')
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    html_content = URI.open(url).read
    @value = JSON.parse(html_content)['found']
    @score = 0
    check = @new_word.all? { |letter| @new_word.count(letter) <= @grid.count(letter) }
    @finish = Time.now
    @distance = (@finish - @start).to_f.round(2)
    @message = if check == false
      "Sorry but #{@word.downcase} can't be built out of #{@grid}"
    elsif @value == false
      "Sorry but #{@word.downcase} does not seem to be a valid English word..."
    else
      @score = @new_word.count
      "Congratulation!#{@word.downcase} is a valid English word"
    end
  end
end
