class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  before_action :authenticate!

  # GET /users
  def index
    @users = User.all

    render json: @users.as_json(only: %i[id name email created_at updated_at])
  end

  # GET /users/1
  def show
    render json: @user.as_json(only: %i[id name email created_at updated_at])
  end

  # PATCH/PUT /users/1
  def update
    authorize @user

    if User.update_user_params(update_params, @user)
      head '204'
    else
      render json: @user.errors.details, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def update_params
    params.require(:user).permit(:name, :email, :current_password, :password, :password_confirmation)
  end
end
