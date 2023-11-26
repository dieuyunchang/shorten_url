# frozen_string_literal: true

class Api::Users::SessionsController < Devise::SessionsController
  respond_to :json
  protect_from_forgery unless: -> { request.format.json? }
  
  private

  def respond_with(current_user, _opts = {})
    render json: {
      status: { 
        code: 200, message: 'Logged in successfully.',
        data: { user: UserSerializer.new(current_user).serializable_hash }
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, ENV["DEVISE_JWT_SECRET_KEY"]).first
      current_user = User.find(jwt_payload['sub'])
    end
    
    if current_user
      render json: {
        status: 200,
        message: 'Logged out successfully.'
      }, status: :ok
    else
      render json: {
        status: 401,
        error: ["Couldn't find an active session."]
      }, status: :unauthorized
    end
  end
end
