require 'open-uri'
require 'json'

class WordsGameController < ApplicationController
  def game
    @grid = generate_grid
    @start_time = Time.now.to_i


    # generate grid of randomn letters
    # is it a word? https://wagon-dictionary.herokuapp.com/
    # make a timer
  end

  def score
    @attempt = params[:query]
    @word_valid = real_word?
    score_message
    @end_time = Time.now.to_i
    score = compute_score
    # @attempt_valid
  end

  protected

  def generate_grid
    grid = []
    @consonants = ["B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "X", "W", "Y", "Z"]
    @vowels = ["A", "E", "I", "O", "U"]

    10.times { |consonant| grid << @consonants.sample}
    4.times { |vowel| grid << @vowels.sample}
    return grid.shuffle

  end

  def real_word?
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    @attempt_value = open(url).read
    @valid = JSON.parse(@attempt_value)
    @valid['found']
  end

  # def attempt_valid?
  #   array_word = @attempt_value.upcase.split(//)

  #   array_word.all? do |letter|
  #     @attempt_value.count(letter.downcase) <= @grid.count(letter)
  # end

  def score_message
    @score_message = if @valid['found'] == true
      "your word is valid - it is #{@valid['length']} characters"
    else
      "your word is invalid  -- try again"
    end

  end

  def compute_score
    time = @end_time - @start_time
    length = @valid['length']
    @score = time > 60.0 ? 0 : length * (1.0 - time / 60.0)
  end
end


# time > 60.0 ? 0 : length * (1.0 - time / 60.0)
