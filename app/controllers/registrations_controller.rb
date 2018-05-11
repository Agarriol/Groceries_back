class RegistrationsController < RailsJwtAuth::RegistrationsController
  def create
    user = RailsJwtAuth.model.new(user_create_params)
    user.save ? render_registration(user) : render_422(user.errors)
  end

  private

  # Only allow a trusted parameter "white list" through.
  def user_create_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
