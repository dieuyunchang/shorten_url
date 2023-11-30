# frozen_string_literal: true

class Api::ApisController < ApplicationController
  REQUIRE_LOGIN_ERROR_MESSAGE = "Please login to use this function"
  protect_from_forgery unless: -> { request.format.json? }

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  helper_method :current_user

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name])
  end

  def authenticate_user!
    unless request.headers['Authorization'].present?
      render json: { error: REQUIRE_LOGIN_ERROR_MESSAGE }, status: :unauthorized
      return
    end
    
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, ENV["DEVISE_JWT_SECRET_KEY"]).first
    
    @current_user = User.find_by_jti(jwt_payload['jti'])
    unless @current_user
      render json: { error: REQUIRE_LOGIN_ERROR_MESSAGE }, status: :unauthorized
      return
    end
  rescue StandardError => e
    render json: { error: REQUIRE_LOGIN_ERROR_MESSAGE }, status: :unauthorized
  end
end
