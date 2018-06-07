class VotesController < ApplicationController
  before_action :set_vote, only: %i[show destroy]
  before_action :authenticate!

  # POST /votes
  def create
    # @vote = Vote.new(vote_params)
    @vote = List.find(params[:list_id]).items.find(params[:item_id]).votes.new()
    @vote.user = current_user

    authorize @vote

    if @vote.save
      render json: @vote, status: :created # , location: @vote
    else
      render json: @vote.errors.details, status: :unprocessable_entity
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
