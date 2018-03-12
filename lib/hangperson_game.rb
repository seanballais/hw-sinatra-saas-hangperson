class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

  def guess(letter)
    if letter == ''
      raise ArgumentError.new('No letter in guess.')
    elsif letter !~ /^[[:alpha:]]$/
      raise ArgumentError.new('Not a letter.')
    elsif letter == nil
      raise ArgumentError.new('Argument is null.')
    end

    letter.downcase!
    if self.word.include? letter
      if not self.guesses.include? letter
        @guesses += letter
        return true
      else
        return false
      end
    end
    
    if not self.wrong_guesses.include? letter
      @wrong_guesses += letter
    end
    return false
  end

  def guess_several_letters(game_obj, letters)
    letters.split('').each { |letter| game_obj.guess(letter) }
  end

  def word_with_guesses
    displayed_word = ''
    self.word.split('').each do |letter|
      if self.guesses.include? letter
        displayed_word += letter
      else
        displayed_word += '-'
      end
    end

    return displayed_word
  end

  def check_win_or_lose
    guessed_letters = self.word_with_guesses
    
    if self.wrong_guesses.length >= 7
      return :lose
    elsif guessed_letters == self.word
      return :win
    else guessed_letters =~ /^[#{word}-]*$/
      return :play
    end
  end

end
