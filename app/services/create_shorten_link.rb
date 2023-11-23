class CreateShortenLink < ApplicationService
  result :shortened_link

  def initialize(url)
    @url = url
  end

  def call
    return error("Url can not be blank") if url.blank?
    return success(shortened_link: shortened_link(find_duplicate.short_code)) if find_duplicate.present?
    
    shortened_url = ShortenedUrl.new(original_url: url, sanitize_url: sanitize_url)
    if shortened_url.valid? && shortened_url.save
      short_code = Encode.new(shortened_url.reload.id).call
      if short_code
        shortened_url.update(short_code: short_code)
        success(shortened_link: shortened_link(short_code))
      else
        return error("Shorten URL can't be generated")  
      end
    else
      return error(shortened_url.errors.full_messages.join(","))
    end
  end

  private

  attr_reader :url

  def shortened_link(code)
    "http://localhost:3000/#{code}" # update to use env for main url
  end

  def find_duplicate
    @find_duplicate ||= ShortenedUrl.find_by_sanitize_url sanitize_url
  end

  def sanitize_url
    @sanitize_url ||= url.strip.downcase.gsub /(https?:\/\/|(www\.))/, ""
  end
end
