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
      it 'name very long (max. 100)' do
        @item.name = Faker::String.random(101)
        expect(@item).not_to be_valid
        expect(@item.errors.details).to eq(name: [{error: :too_long, count: 100}])
      end
      it 'title can not be empty' do
        @item.name = nil
        expect(@item).not_to be_valid
        expect(@item.errors.details).to eq(name: [{error: :blank}])
      end
      it 'title can not repeat' do
        @item2 = FactoryBot.build(:item, name: @item.name)
        expect(@item2).not_to be_valid
        expect(@item2.errors.details).to eq(name: [{error: :taken, value: @item2.name}])
      end
    end
    context 'when price is not valid' do
      it 'price can not be empty' do
        @item.price = nil
        expect(@item).not_to be_valid
        expect(@item.errors.details).to eq(price: [{error: :blank}])
      end
      it 'price must be number' do
        @item.price = 'no soy un numero'
        expect(@item).not_to be_valid
        expect(@item.errors.details).to eq(price: [{error: :not_a_number, value: 'no soy un numero'}])
      end
    end
  end
end
