class ListPolicy < ApplicationPolicy
  attr_reader :user, :list

  def initialize(user, list)
    @user = user
    @list = list
  end

  def update?
    @permit = @user.id == @list.user_id
  end

  def destroy?
    @permit = @user.id == @list.user_id
  end

  class Scope < Scope
    def resolve
      Scope
    end
  end
end
