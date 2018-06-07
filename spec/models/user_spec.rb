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

  describe 'relations' do
    it 'list - user' do
      expect(@user).to respond_to(:lists)
    end
  end

  describe 'Validations' do
    context 'when name is not valid' do
      it 'name is very long (max. 100 charactesrs)' do
        @user.name = 'm' * 101
        expect(@user).not_to be_valid
        expect(@user.errors.details).to eq(name: [{error: :too_long, count: 100}])
      end
      it 'name can not be empty' do
        @user.name = nil
        expect(@user).not_to be_valid
        expect(@user.errors.details).to eq(name: [{error: :blank}])
      end
    end
  end
end
