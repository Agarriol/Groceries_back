class ItemPolicy < ApplicationPolicy
  attr_reader :user, :item

  def initialize(user, item)
    @user = user
    @item = item
  end

  def create?
    @permit = (@item.list.state == true)

    @permit
  end

  def update?
    @permit = ((@user.id == @item.list.user_id) || (@user.id == @item.user_id))
    @permit = false if @item.list.state == false

    @permit
  end

  def destroy?
    @permit = ((@user.id == @item.list.user_id) || (@user.id == @item.user_id))
    @permit = false if @item.list.state == false

    @permit
  end

  class Scope < Scope
    def resolve
      Scope
    end
  end
end
