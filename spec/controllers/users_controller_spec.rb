require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    @user = create(:user)
    @user2 = create(:user, name: 'david')
    @id = @user.id.to_s
    @id2 = @user2.id.to_s
  end

  describe 'GET #index' do
    context 'when user is not logged' do
      before do
        sign_out
        get :index
      end

      it 'returns 401 Http status code' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is logged' do
      before do
        sign_in @user
        get :index

        @data = JSON.parse(response.body)
      end

      it 'returns 200 Http status code' do
        expect(response).to have_http_status(200)
      end

      it 'returns all resources' do
        expect(@data.size).to eq User.all.size
      end

      it 'returns correct info' do
        expect(@data.first.keys).to include('id',
                                            'name',
                                            'email',
                                            'created_at',
                                            'updated_at')
      end

      it 'returns correct data' do
        expect(@data.first['id']).to eq(@user.id)
        expect(@data.first['name']).to eq(@user.name)
        expect(@data.first['email']).to eq(@user.email)
      end
    end
  end

  describe 'GET #show' do
    context 'when user is logged' do
      before do
        sign_in @user
      end

      context 'when user exist' do
        before do
          get :show, params: {id: @id}
          @data = JSON.parse(response.body)
        end

        it 'returns 200 Http status code if user exist' do
          expect(response).to have_http_status(200)
        end

        it 'returns correct info' do
          expect(@data.keys).to include('id',
                                        'name',
                                        'email',
                                        'created_at',
                                        'updated_at')
          expect(@data.keys).not_to include('password_digest',
                                            'auth_tokens')
          expect(@data.keys.size).to eq(5)
        end

        it 'returns correct data' do
          expect(@data['id']).to eq(@user.id)
          expect(@data['name']).to eq(@user.name)
          expect(@data['email']).to eq(@user.email)
        end
      end

      context 'when user does not exist' do
        before do
          get :show, params: {id: 'AAA'}
        end

        it 'returns 404 Http status code if user not exist' do
          expect(response).to have_http_status(404)
        end
      end
    end
  end

  describe 'UPDATE #update' do
    let(:attributes) { {name: 'unnombre'} }
    let(:bad_attributes) { {email: ''} }
    # let(:user_before_update) { @user2 }

    context 'when user is logged and have licence' do
      before do
        sign_in @user2
        put :update, params: {id: @id2, user: attributes}
      end

      it 'returns 204 Http status code' do
        expect(response).to have_http_status(204)
      end

      it 'returns all resources' do
        expect(response.body).to be_empty
      end

      it 'updates the resource' do
        @user2.reload
        # ¿Por qué son iguales, se actualiza user_before_update?
        # expect(@user2).not_to eq(user_before_update)

        attributes.each do |field, value|
          expect(@user2.send(field)).to eq(value)
        end
      end
    end

    context 'when user is logged and have not licence' do
      before do
        sign_in @user2
        put :update, params: {id: @id, user: attributes}
      end

      it 'returns 403 Http status code' do
        expect(response).to have_http_status(403)
      end

      it 'updates the resource' do
        @user2.reload

        attributes.each do |field, value|
          expect(@user2.send(field)).not_to eq(value)
        end
      end
    end

    context 'when user is logged but edit_user not exist' do
      before do
        sign_in @user2
        put :update, params: {id: 'AAA', user: attributes}
      end

      it 'returns 404 Http status code' do
        expect(response).to have_http_status(404)
      end
    end

    context 'when user is logged but data is not valid' do
      before do
        sign_in @user2
        put :update, params: {id: @id2, user: bad_attributes}

        @data = JSON.parse(response.body)
      end

      it 'returns 422 Http status code' do
        expect(response).to have_http_status(422)
      end

      it 'not updates the resource' do
        @user2.reload

        bad_attributes.each do |field, value|
          expect(@user2.send(field)).not_to eq(value)
        end
      end

      it 'response ActiveModel error type' do
        expect(@data).to eq("email"=>[{"error"=>"blank"}])
      end
    end
  end
end
