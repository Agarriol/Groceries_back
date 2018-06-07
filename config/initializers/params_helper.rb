RailsJwtAuth::ParamsHelper.module_eval do
  private

  def registration_create_params
    # params.require(:user).permit(:name, :email, :password, :password_confirmation)
    params.require(RailsJwtAuth.model_name.underscore).permit(
      :name, RailsJwtAuth.auth_field_name, :password, :password_confirmation
    )
  end
end
