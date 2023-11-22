class Encode
  ALPHABET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".freeze
  BASE = ALPHABET.length # can move to ENV
  MAX_ENCODED_LENGTH = 6
  
  def initialize(number)
    @number = number
  end

  def call
    return ALPHABET.first if  number.nil? || number.zero?

    result = ""
    i = number
    while i > 0 do
      index = i % BASE
      char = ALPHABET[index]
      result.prepend char
      i = i / BASE
    end

    result = result.rjust(MAX_ENCODED_LENGTH, ALPHABET.first)
    result[0, MAX_ENCODED_LENGTH]
  end

  private

  attr_reader :number
end
