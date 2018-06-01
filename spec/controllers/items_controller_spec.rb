require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
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
  end

  describe 'GET #index' do
    context 'when user is not logged' do
      before do
        sign_out
        get :index, params: {list_id: 1, format: :json}
      end

      it 'returns 401 Http status code' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is logged' do
      before do
        sign_in @user
      end

      describe 'request' do
        before do
          get :index, params: {list_id: 1, format: :json}
        end

        it 'returns 200 Http status code' do
          expect(response).to have_http_status(200)
        end

        it 'returns all resources' do
          expect(data['data'].size).to eq 2
        end

        it 'returns correct information' do
          expect(data['data'].first.keys).to include('id',
                                                     'name',
                                                     'price',
                                                     'list_id',
                                                     'created_at')
        end

        it 'returns correct data' do
          expect(data['data'].first['id']).to eq(@item.id)
          expect(data['data'].first['name']).to eq(@item.name)
          expect(data['data'].first['price']).to eq(@item.price)
          expect(data['data'].first['list_id']).to eq(@item.list_id)
          # TODO, # expect(data['data'].first['created_at']).to eq(@item.created_at)
        end
      end

      describe 'order' do
        describe 'created_at' do
          describe 'asc' do
            before do
              get :index, params: {list_id: 1, sort: 'created_at'}
            end

            it 'returns ordered resources' do
              expect(data['data'].first['id']).to eq(Item.order(created_at: 'asc').first.id)
            end
          end

          describe 'desc' do
            before do
              get :index, params: {list_id: 1, sort: '-created_at'}
            end

            it 'returns ordered resources' do
              expect(data['data'].last['id']).to eq(Item.order(created_at: 'desc').last.id)
            end
          end
        end
      end
    end
  end

  describe 'POST #create' do
    let(:item_attributes) { attributes_for(:item, name: 'lista 3', price: 22.56) }
    let(:item_attributes_bad_name) { attributes_for(:item, name: '', price: 'descriptcion 3') }
    let(:item_attributes_bad_price) { attributes_for(:item, name: 'lista 3', price: '') }

    context 'when user is not logged' do
      before do
        sign_out
        post :create, params: {list_id: 1, item: item_attributes}
      end

      it 'returns 401 Http status code' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is logged' do
      context 'when list is closed' do
        before do
          sign_in @user
          post :create, params: {list_id: @list2.id, id: @item3.id, item: item_attributes}
        end

        it 'returns 403 Http status code' do
          expect(response).to have_http_status(403)
        end

        it 'dont create item' do
          expect { post :create, params: {list_id: @list2.id, id: @item3.id, item: item_attributes} }.to change(Item, :count).by(0)
        end
      end

      context 'with correct params' do
        before do
          sign_in @user
          post :create, params: {list_id: 1, item: item_attributes}
        end

        it 'returns 201 Http status code' do
          expect(response).to have_http_status(201)
        end

        it 'returns correct information' do
          expect(data.keys).to include('id',
                                       'name',
                                       'price',
                                       'list_id',
                                       'created_at')
        end

        it 'returns correct data' do
          expect(data['name']).to eq(item_attributes[:name])
          expect(data['price']).to eq(item_attributes[:price])
          expect(data['list_id']).to eq(item_attributes[:list_id])
        end
      end

      context 'with incorrect params' do
        context 'empty name, price not number' do
          before do
            sign_in @user
            post :create, params: {list_id: 1, item: item_attributes_bad_name}
          end

          it 'returns 422 Http status code' do
            expect(response).to have_http_status(422)
          end

          it 'body has an ActiveModel error' do
            expect(data).to eq("name"=>["can't be blank"], "price"=>["is not a number"])
          end
        end
        context 'empty price' do
          before do
            sign_in @user
            post :create, params: {list_id: 1, item: item_attributes_bad_price}
          end

          it 'returns 422 Http status code' do
            expect(response).to have_http_status(422)
          end

          it 'body has an ActiveModel error' do
            expect(data).to eq("price"=>["can't be blank", "is not a number"])
          end
        end

        context 'repeat name' do
          before do
            sign_in @user
            post :create, params: {list_id: 1, item: {name: @item.name, price: @item.price}}
          end

          it 'body has an ActiveModel error' do
            expect(data).to eq("name"=>["has already been taken"])
          end
        end
      end
    end
  end

  describe 'PUT #update' do
    let(:item_attributes) { attributes_for(:item, name: 'lista 3', price: 22.56) }
    let(:item_attributes_bad_name) { attributes_for(:item, name: '', price: 'descriptcion 3') }
    let(:item_attributes_bad_price) { attributes_for(:item, name: 'lista 3', price: '') }

    context 'when user is not logged' do
      before do
        sign_out
        put :update, params: {list_id: 1, id: 1, item: item_attributes}
      end

      it 'returns 401 Http status code' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is logged' do
      context 'when list is closed' do
        before do
          sign_in @user
          put :update, params: {list_id: @list2.id, id: @item3.id, item: item_attributes}
        end

        it 'returns 403 Http status code' do
          expect(response).to have_http_status(403)
        end

        it 'dont update item' do
          expect(@item3['name']).not_to eq(item_attributes['name'])
        end
      end

      context 'with correct params' do
        before do
          sign_in @user
          put :update, params: {list_id: 1, id: 1, item: item_attributes}
        end

        it 'returns 204 Http status code' do
          expect(response).to have_http_status(204)
        end

        it 'returns the correct information (empty)' do
          expect(response.body).to be_empty
        end
      end

      context 'when item dont exist' do
        before do
          sign_in @user
          put :update, params: {list_id: 1, id: 1984, item: item_attributes}
        end

        it 'returns 404 Http status code' do
          expect(response).to have_http_status(404)
        end
      end

      context 'when user is not authorized' do
        before do
          sign_in @user2
          put :update, params: {list_id: 1, id: 1, item: item_attributes}
        end

        it 'returns 403 Http status code' do
          expect(response).to have_http_status(403)
        end

        it 'dont update item' do
          expect(@item['name']).not_to eq(item_attributes['name'])
        end
      end

      context 'with incorrect params ' do
        context 'bad name, bad price' do
          before do
            sign_in @user
            put :update, params: {list_id: 1, id: 1, item: item_attributes_bad_name}
          end

          it 'returns 422 Http status code' do
            expect(response).to have_http_status(422)
          end

          it 'body has an ActiveModel error' do
            expect(data).to eq("name"=>["can't be blank"], "price"=>["is not a number"])
          end

          it 'dont update list' do
            expect(@item['name']).not_to eq(item_attributes_bad_name['name'])
          end
        end

        context 'repeat name' do
          before do
            sign_in @user
            put :update, params: {list_id: 1, id: 1, item: {name: @item2.name, price: @item.price}}
          end

          it 'body has an ActiveModel error' do
            expect(data).to eq("name"=>["has already been taken"])
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is not logged' do
      before do
        sign_out
        delete :destroy, params: {list_id: 1, id: @list['id']}
      end

      it 'returns 401 Http status code' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is logged' do
      context 'when list is closed' do
        before do
          sign_in @user
          delete :destroy, params: {list_id: @list2.id, id: @item3.id}
        end

        it 'returns 403 Http status code' do
          expect(response).to have_http_status(403)
        end

        it 'dont delete item' do
          expect { delete :destroy, params: {list_id: @list2.id, id: @item3.id} }.to change(Item, :count).by(0)
        end
      end

      context 'with correct params' do
        before do
          sign_in @user
          delete :destroy, params: {list_id: 1, id: @list['id']}
        end

        it 'returns 204 Http status code' do
          expect(response).to have_http_status(204)
        end

        it 'returns the correct information (empty)' do
          expect(response.body).to be_empty
        end
      end

      context 'when item dont exist' do
        before do
          sign_in @user
          delete :destroy, params: {list_id: 1, id: 1589}
        end

        it 'returns 404 Http status code' do
          expect(response).to have_http_status(404)
        end
      end

      context 'when user is not authorized' do
        before do
          sign_in @user2
          delete :destroy, params: {list_id: 1, id: @item['id']}
        end

        it 'returns 403 Http status code' do
          expect(response).to have_http_status(403)
        end

        it 'dont delete item' do
          # TODO, mal, en caso de borrarlo realmente lo borraría en before do.
          expect { delete :destroy, params: {list_id: 1, id: @item['id']} }.to change(Item, :count).by(0)
        end
      end
    end
  end
end
