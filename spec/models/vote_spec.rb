require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @list = FactoryBot.create(:list)
    @item = FactoryBot.create(:item)
    @vote = FactoryBot.create(:vote)
  end

  context 'when vote is valid' do
    it 'is valid' do
      expect(@vote).to be_valid
    end
  end

  describe 'relations' do
    it 'vote - item' do
      expect(@vote).to respond_to(:item)
    end
    it 'vote - user' do
      expect(@vote).to respond_to(:user)
    end
  end

  describe 'Validations' do
    context 'when item-user is repeat' do
      before do
        @vote1 = FactoryBot.build(:vote)
      end

      it 'can not be repeat' do
        expect(@vote1).not_to be_valid
        expect(@vote1.errors.details).to eq(item_id: [{error: :taken, value: @vote1.item_id}])
      end
    end
  end
end
