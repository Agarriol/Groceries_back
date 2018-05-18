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
      it 'title very long' do
        @list.title = Faker::String.random(1..100)
        expect(@list).to be_valid
        @list.title = Faker::String.random(101)
        expect(@list).not_to be_valid
      end
      it 'title empty' do
        expect(@list).to be_valid
        @list.title = nil
        expect(@list).not_to be_valid
      end
    end
    context 'when description is not valid' do
      it 'description very long' do
        @list.description = Faker::String.random(1..5000)
        expect(@list).to be_valid
        @list.description = Faker::String.random(5001)
        expect(@list).not_to be_valid
      end
    end
    context 'when state is not valid' do
      it 'state very long' do
        #TODO, este... sea como sea siempre esa bien. 
        # Si se mete false es false y para cualquier otro valor es true
      end
    end
  end
end
