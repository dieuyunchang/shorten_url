class Encode
  ALPHABET = "1nxNI0mFiJ8TgbopqrvyuswctOfaMWL7C5k9SG6EDhBHejK42dzPQRAlUV3XYZ".freeze
  BASE = ALPHABET.length # can move to ENV
  MAX_LENGTH = 6

  def initialize(number)
    @number = number
  end

  def call
    return false if  number.nil? || number.zero?

    result = ""
    i = number
    while i > 0 do
      index = i % BASE
      char = ALPHABET[index]
      result.prepend char
      i = i / BASE
    end

    result.length > MAX_LENGTH ? false : result
  end

  private

  attr_reader :number
end
