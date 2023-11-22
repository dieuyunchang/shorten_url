class Decode
  def initialize(string)
    @string = string
  end

  def call
    return 0 if string.nil? || string.empty?
    number = 0

    string.reverse.each_char.with_index do |char, index|
      power = Encode::BASE**index
      index = Encode::ALPHABET.index(char)
      number += index * power
    end

    number
  end

  private

  attr_reader :string
end
