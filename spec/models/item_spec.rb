require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @list = FactoryBot.create(:list)
    @item = FactoryBot.create(:item)
  end

  context 'when item is valid' do
    it 'is valid' do
      expect(@item).to be_valid
    end
  end

  describe 'relations' do
    it 'item - list' do
      expect(@item).to respond_to(:list)
    end
  end

  describe 'Validations' do
    context 'when name is not valid' do
      it 'name very long' do
        @item.name = Faker::String.random(1..100)
        expect(@item).to be_valid
        @item.name = Faker::String.random(101)
        expect(@item).not_to be_valid
      end
      it 'title empty' do
        expect(@item).to be_valid
        @item.name = nil
        expect(@item).not_to be_valid
      end
      it 'title repeat' do
        expect(FactoryBot.build(:item, name: @item.name)).not_to be_valid
      end
    end
    context 'when price is not valid' do
      it 'price empty' do
        expect(@item).to be_valid
        @item.price = nil
        expect(@item).not_to be_valid
      end
      it 'price dont number' do
        expect(@item).to be_valid
        @item.price = 'no soy un numero'
        expect(@item).not_to be_valid
      end
    end
  end
end
