class ApplicationController < ActionController::API
  include Pundit
  include RailsJwtAuth::WardenHelper

  rescue_from Pundit::NotAuthorizedError, with: :render_403
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def render_403
    render json: {}, status: 403
  end

  def render_404
    render json: {}, status: 404
  end
end
