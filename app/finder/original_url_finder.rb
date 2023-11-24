class OriginalUrlFinder
  def initialize(short_code)
    @short_code = short_code
  end

  def find
    return if short_code.blank?
    return if short_code.length > Encode::MAX_LENGTH

    id = Decode.new(short_code).call 
    id ? ShortenedUrl.find_by_id(id)&.original_url : nil
  end

  private
  attr_reader :short_code
end
