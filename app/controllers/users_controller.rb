class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  before_action :authenticate!

  # GET /users
  def index
    @users = User.all.select('id', 'name', 'email', 'created_at', 'updated_at')

    render json: @users
  end

  # GET /users/1
  def show
    @user_show = User.select('id', 'name', 'email', 'created_at', 'updated_at').find(params[:id])
    render json: @user_show
  end

  # PATCH/PUT /users/1
  def update
    authorize @user
    if @user.update(user_params)
      render json: nil, status: '204'
    else
      render json: @user.errors.details, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:name, :email, :password_digest, :auth_tokens)
  end
end
