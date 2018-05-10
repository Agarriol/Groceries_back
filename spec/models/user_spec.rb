require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'when user is valid' do
    it 'is valid' do
      expect(@user).to be_valid
    end
  end

  context 'when name is not valid' do
    it 'name very long' do
      @user.name = 'asdfghjklñasdfghjklñasdfghjklñasdfghjklñasdfghjklñasdfghjklñasdfghjklñasdfghjklñasdfghjklñasdfghjklñ'
      expect(@user).to be_valid
      @user.name = 'asdfghjklñ asdfghjklñasdfghjklñasdfghjklñasdfghjklñasdfghjklñasdfghjklñasdfghjklñasdfghjklñasdfghjklñ'
      expect(@user).not_to be_valid
    end
    it 'name empty' do
      expect(@user).to be_valid
      @user.name = nil
      expect(@user).not_to be_valid
    end
  end
end
