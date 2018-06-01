require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:data) { JSON.parse(response.body) }

  before do
    @user = create(:user)
    @user2 = create(:user, name: 'david')
    @id = @user.id.to_s
    @id2 = @user2.id.to_s

    @list = create(:list)
    @list2 = create(:list, title: 'lista 2', description: 'descriptcion 2', state: 'false', user_id: '2')

    @lists = @user.lists

    @item = create(:item)
    @item2 = create(:item)
    @item3 = create(:item, list_id: 2)

    @vote = create(:vote)
    @vote2 = create(:vote, item_id: 3, user_id: 2)
  end

  describe 'POST #create' do
    let(:vote_attributes) { attributes_for(:vote, user_id: '1', item_id: 2) }

    context 'when user is not logged' do
      before do
        sign_out
        post :create, params: {list_id: 1, item_id: 2, vote: vote_attributes}
      end

      it 'returns 401 Http status code' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is logged' do
      context 'when list is closed' do
        before do
          sign_in @user
          post :create, params: {list_id: @list2.id, item_id: @item3.id, vote: vote_attributes}
        end

        it 'returns 403 Http status code' do
          expect(response).to have_http_status(403)
        end

        it 'dont create item' do
          expect { post :create, params: {list_id: @list2.id, item_id: @item3.id, vote: vote_attributes} }.to change(Vote, :count).by(0)
        end
      end

      context 'with correct params' do
        before do
          sign_in @user
          post :create, params: {list_id: '1', item_id: '2', vote: vote_attributes}
        end

        it 'returns 201 Http status code' do
          expect(response).to have_http_status(201)
        end

        it 'returns correct information' do
          expect(data.keys).to include('id',
                                       'user_id',
                                       'item_id')
        end

        it 'returns correct data' do
          expect(data['user_id'].to_s).to eq(vote_attributes[:user_id])
          expect(data['item_id']).to eq(vote_attributes[:item_id])
        end
      end

      context 'with incorrect params' do
        context 'repeat item-user' do
          before do
            sign_in @user
            post :create, params: {list_id: 1, item_id: 1, vote: vote_attributes}
            post :create, params: {list_id: 1, item_id: 1, vote: vote_attributes}
          end

          it 'returns 422 Http status code' do
            expect(response).to have_http_status(422)
          end

          it 'body has an ActiveModel error' do
            expect(data).to eq("item_id"=>["has already been taken"])
          end
        end

      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is not logged' do
      before do
        sign_out
        delete :destroy, params: {list_id: 1, item_id: 1, id: 1}
      end

      it 'returns 401 Http status code' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is logged' do
      context 'when list is closed' do
        before do
          sign_in @user
          delete :destroy, params: {list_id: @list2.id, item_id: @item3.id, id: @vote2['id']}
        end

        it 'returns 403 Http status code' do
          expect(response).to have_http_status(403)
        end

        it 'dont update item' do
          expect { delete :destroy, params: {list_id: @list2.id, item_id: @item3.id, id: @vote2['id']}}.to change(Vote, :count).by(0)
        end
      end

      context 'with correct params' do
        before do
          sign_in @user
          delete :destroy, params: {list_id: 1, item_id: 1, id: @vote['id']}
        end

        it 'returns 204 Http status code' do
          expect(response).to have_http_status(204)
        end

        it 'returns the correct information (empty)' do
          expect(response.body).to be_empty
        end
      end

      context 'when vote dont exist' do
        before do
          sign_in @user
          delete :destroy, params: {list_id: 1, item_id: 1, id: 1589}
        end

        it 'returns 404 Http status code' do
          expect(response).to have_http_status(404)
        end
      end

      context 'when user is not authorized' do
        before do
          sign_in @user2
          delete :destroy, params: {list_id: 1, item_id: 1, id: @vote['id']}
        end

        it 'returns 403 Http status code' do
          expect(response).to have_http_status(403)
        end

        it 'dont delete list' do
          expect { delete :destroy, params: {list_id: 1, item_id: 1, id: @vote['id']} }.to change(Vote, :count).by(0)
        end
      end
    end
  end
end
