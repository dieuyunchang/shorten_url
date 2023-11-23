# frozen_string_literal: true

class Api::ApisController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
end
