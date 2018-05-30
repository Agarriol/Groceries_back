class VotesController < ApplicationController
  before_action :set_vote, only: %i[show destroy]
  before_action :authenticate!

  # GET /votes
  def index
    # @votes = Vote.all
    @vote_index = Vote.find_by(user_id: current_user, item_id: params[:item_id])
    
    render json: @vote_index
  end

  # GET /votes/1
  def show
    @vote_show = Vote.find_by(user_id: current_user, item_id: params[:item_id])

    render json: @vote_show
  end

  # POST /votes
  def create
    # @vote = Vote.new(vote_params)
    @vote = List.find(params[:list_id]).items.find(params[:item_id]).votes.new()
    @vote.user = current_user

    authorize @vote

    if @vote.save
      render json: @vote, status: :created# , location: @vote
    else
      render json: @vote.errors, status: :unprocessable_entity
    end
  end

  # DELETE /votes/1
  def destroy
    authorize @vote
    @vote.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_vote
    @vote = Vote.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def vote_params
    params.require(:vote).permit(:user_id, :item_id)
  end
end
