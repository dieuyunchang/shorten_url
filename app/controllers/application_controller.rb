class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound do
    render "errors/not_found", status: :not_found
  end
end
