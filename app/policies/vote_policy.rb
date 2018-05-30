class VotePolicy < ApplicationPolicy
  attr_reader :user, :vote

  def initialize(user, vote)
    @user = user
    @vote = vote
  end

  def create?
    @permit = @user.id == @vote.user_id
  end

  def destroy?
    @permit = @user.id == @vote.user_id
  end

  class Scope < Scope
    def resolve
      Scope
    end
  end
end
