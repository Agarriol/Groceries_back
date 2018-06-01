class VotePolicy < ApplicationPolicy
  attr_reader :user, :vote

  def initialize(user, vote)
    @user = user
    @vote = vote
  end

  def create?
    @permit = @user.id == @vote.user_id
    @permit = false if @vote.item.list.state == false

    @permit
  end

  def destroy?
    @permit = @user.id == @vote.user_id
    @permit = false if @vote.item.list.state == false

    @permit
  end

  class Scope < Scope
    def resolve
      Scope
    end
  end
end
