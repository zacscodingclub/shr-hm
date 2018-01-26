require 'pry'

module Hangman
  class Game
    # set a default path here, but this could be modified accept any path
    # using ARGV in the bin file and passing that as an argument
    def initialize(path = "./data/dict.txt")
      @path = path
      @misses = 0
      @word = select_word
      @letters_hash = word_to_histogram
    end

    def start
      puts "Welcome to CLI Hangman!"

      until over?
        display_board
        make_guess
      end

      game_over
    end

    def game_over
      puts won? ? "Congratulations! You won!" : "Oh noes! You lost"
    end

    def over?
      won? || misses_remaining.zero?
    end

    def won?
      !@letters_hash.keys.any? { |k| @letters_hash[k] > 0 }
    end

    def make_guess
      puts "You have #{misses_remaining} misses left! To quit, type 'quit' or 'exit'."
      puts "Pick a letter:"
      guess = gets.chomp.downcase

      if guess == "exit" || guess == "quit"
        puts "You exited the game.  Good luck next time!"
        exit
      end

      if @letters_hash[guess]
        puts "You found '#{guess}' in the word!"
        @letters_hash[guess] = 0
      else
        puts "Uh oh, couldn't find '#{guess}' in the word.  Please try again!"
        @misses += 1
      end
    end

    def display_board
      str = ""
      @word.each_char do |c|
        str += @letters_hash[c] == 0 ? " #{c} " : " _ "
      end

      puts "Current Board: #{str}"
    end

    def select_word
      all_words = File.foreach(@path).map { |l| l.gsub("\n", "") }
      all_words.sample
    end

    def word_to_histogram
      @word.each_char.with_object({}) { |c, h| h[c] = h.fetch(c, 0) + 1 }
    end

    def misses_remaining
      6 - @misses
    end
  end
end
