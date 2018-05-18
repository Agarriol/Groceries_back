class UserPolicy
  attr_reader :user, :edit_user

  def initialize(user, edit_user)
    @user = user
    @edit_user = edit_user
  end

  def update?
    if @edit_user.id == @user.id
      @permit = true
    else
      @permit = false
    end
    @permit
  end

  def edit?
    update?
  end
end
