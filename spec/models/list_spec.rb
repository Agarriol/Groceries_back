require 'rails_helper'

RSpec.describe List, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @list = FactoryBot.create(:list)
  end

  context 'when list is valid' do
    it 'is valid' do
      expect(@list).to be_valid
    end
  end

  describe 'relations' do
    it 'list - user' do
      expect(@list).to respond_to(:user)
    end
  end

  describe 'Validations' do
    context 'when title is not valid' do
      it 'title very long (max. 100 characters)' do
        @list.title = 'm' * 101
        expect(@list).not_to be_valid
        expect(@list.errors.details).to eq(title: [{error: :too_long, count: 100}])
      end
      it 'title can not be empty' do
        @list.title = nil
        expect(@list).not_to be_valid
        expect(@list.errors.details).to eq(title: [{error: :blank}])
      end
    end
    context 'when description is not valid' do
      it 'description very long (max. 5000 characters)' do
        @list.description = 'm' * 5001
        expect(@list).not_to be_valid
        expect(@list.errors.details).to eq(description: [{error: :too_long, count: 5000}])
      end
    end
  end
end
