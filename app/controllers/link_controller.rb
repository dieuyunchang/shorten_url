class LinkController < ApplicationController
  def index; end

  def show
    short_code = params[:short_code]

    original_url = OriginalUrlFinder.new(short_code).find
    if original_url
      redirect_to original_url, allow_other_host: true 
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
