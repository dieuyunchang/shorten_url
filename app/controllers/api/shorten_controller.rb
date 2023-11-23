class Api::ShortenController < Api::ApisController
  
  def create
    create_shorten_link = CreateShortenLink.call(original_url)
    if create_shorten_link.successful?
      render json: { data: { shortened_link: create_shorten_link.shortened_link } }, status: :created
    else
      render json: { error: create_shorten_link.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e }, status: :internal_server_error
  end

  private
  
  def original_url
    params.require(:original_url)
  end
end
