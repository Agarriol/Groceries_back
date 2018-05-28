class ItemPolicy < ApplicationPolicy
  attr_reader :user, :item

  def initialize(user, item)
    @user = user
    @item = item
  end

  def update?
    @permit = ((@user.id == @item.list.user_id) || (@user.id == @item.user_id))
  end

  def destroy?
    @permit = ((@user.id == @item.list.user_id) || (@user.id == @item.user_id))
  end

  class Scope < Scope
    def resolve
      Scope
    end
  end
end
