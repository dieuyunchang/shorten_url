class LinkController < ApplicationController
  def index; end

  def show
    short_code = params[:short_code]

    shortened_url = ShortenedUrl.find_by_short_code short_code
    if shortened_url
      redirect_to shortened_url.original_url, allow_other_host: true 
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
