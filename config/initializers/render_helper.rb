RailsJwtAuth::RenderHelper.module_eval do
  def render_422(errors)
    errors = errors.details if defined? errors.details

    render json: errors, status: :unprocessable_entity
  end
end
