class CreateShortenLink < ApplicationService
  result :shortened_link

  def initialize(url)
    @url = url
  end

  def call
    return error("Url can not be blank") if url.blank?
    if find_duplicate.present?
      short_code = Encode.new(find_duplicate.id).call
      return success(shortened_link: shortened_link(short_code))
    end
    
    shortened_url = ShortenedUrl.new(original_url: url, sanitize_url: sanitize_url)
    if shortened_url.valid? && shortened_url.save
      short_code = Encode.new(shortened_url.reload.id).call
      if short_code
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
    "#{ENV["HOST_URL"]}#{code}" # update to use env for main url
  end

  def find_duplicate
    ShortenedUrl.find_by_sanitize_url sanitize_url
  end

  def sanitize_url
    @sanitize_url ||= url.strip.downcase.gsub /(https?:\/\/|(www\.))/, ""
  end
end
