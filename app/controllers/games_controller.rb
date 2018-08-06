require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    no_of_letters = rand(4..10)
    for i in 0...no_of_letters do
      @letters << ('a'..'z').to_a.sample
    end
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split(',')

    if !valid_pick?(@letters, @word)
      @result = "Sorry but #{@word} can't be build out of #{@letters.join(',')}"
    else
      url = "https://wagon-dictionary.herokuapp.com/#{@word}"
      url_response = open(url).read
      response = JSON.parse(url_response)
      if( response["found"] == false )
        @result = "Sorry but #{@word} does not seem to be a valid English word..."
      else
        @result = "Congratulations! #{@word} is a valid English word!"
      end
    end
  end
end

private

def valid_pick?(letters, picked)
  letters = letters.dup
  picked.each_char do |c|
    index = letters.index(c)
    if index
      letters.delete_at(index)
    else
      return false
    end
  end
  return true
end
