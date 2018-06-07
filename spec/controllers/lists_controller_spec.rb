require 'rails_helper'

RSpec.describe ListsController, type: :controller do
  let(:data) { JSON.parse(response.body) }

  before do
    @user = create(:user)
    @user2 = create(:user, name: 'david')
    @id = @user.id.to_s
    @id2 = @user2.id.to_s

    @list = create(:list)
    @list2 = create(:list, title: 'lista 2', description: 'descriptcion 2', state: 'false', user_id: '2')

    @lists = @user.lists
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
      end

      describe 'request' do
        before do
          get :index
        end

        it 'returns 200 Http status code' do
          expect(response).to have_http_status(200)
        end

        it 'returns all resources' do
          expect(data.size).to eq 2
        end

        it 'returns correct information' do
          expect(data['data'].first.keys).to include('id',
                                                     'title',
                                                     'description',
                                                     'created_at')
        end

        it 'returns correct data' do
          expect(data['data'].first['id']).to eq(@list.id)
          expect(data['data'].first['title']).to eq(@list.title)
          expect(data['data'].first['description']).to eq(@list.description)
        end
      end

      describe 'pagination' do
        describe '1 per page, page 1' do
          before do
            get :index, params: {page: {number: 1, size: 1}}
          end

          it 'returns paginated resources' do
            expect(data['data'].size).to eq(1)
          end
        end

        describe '1 per page, page 2' do
          before do
            get :index, params: {page: {number: 2, size: 1}}
          end

          it 'returns paginated resources' do
            expect(data['data'].size).to eq(1)
          end
        end

        describe '2 per page, page 1' do
          before do
            get :index, params: {page: {number: 1, size: 2}}
          end

          it 'returns paginated resources' do
            expect(data['data'].size).to eq(2)
          end
        end
      end

      describe 'filters' do
        describe 'title' do
          before do
            get :index, params: {filter: {title: @list.title}}
          end

          it 'returns filtered resources' do
            expect(data['data'].size).to eq(1)
            expect(data['data'].map { |x| x['id'] }).to include(@list.id)
          end
        end

        describe 'description' do
          before do
            get :index, params: {filter: {title: @list.title, description: @list2.description}}
          end

          it 'returns filtered resources' do
            expect(data['data'].size).to eq(0)
          end
        end
      end

      describe 'order' do
        describe 'title' do
          describe 'asc' do
            before do
              get :index, params: {sort: 'title'}
            end

            it 'returns ordered resources' do
              expect(data['data'].first['id']).to eq(List.order(title: 'asc').first.id)
            end
          end

          describe 'desc' do
            before do
              get :index, params: {sort: '-title'}
            end

            it 'returns ordered resources' do
              expect(data['data'].last['id']).to eq(List.order(title: 'desc').last.id)
            end
          end
        end

        describe 'created_at' do
          describe 'asc' do
            before do
              get :index, params: {sort: 'created_at'}
            end

            it 'returns ordered resources' do
              expect(data['data'].first['id']).to eq(List.order(created_at: 'asc').first.id)
            end
          end

          describe 'desc' do
            before do
              get :index, params: {sort: '-created_at'}
            end

            it 'returns ordered resources' do
              expect(data['data'].last['id']).to eq(List.order(created_at: 'desc').last.id)
            end
          end
        end
      end
    end
  end

  describe 'GET #show' do
    context 'when user is not logged' do
      before do
        sign_out
        get :show, params: {id: @id}
      end

      it 'returns 401 Http status code' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is logged' do
      context 'exist the list' do
        before do
          sign_in @user
          get :show, params: {id: @id}
        end

        it 'returns 200 Http status code' do
          expect(response).to have_http_status(200)
        end

        it 'returns correct information' do
          expect(data.keys).to include('id',
                                       'title',
                                       'description',
                                       'created_at')
        end

        it 'returns correct data' do
          expect(data['id']).to eq(@list.id)
          expect(data['title']).to eq(@list.title)
          expect(data['description']).to eq(@list.description)
        end
      end

      context 'not exist the list' do
        before do
          sign_in @user
          get :show, params: {id: 55}
        end

        it 'returns 404 Http status code' do
          expect(response).to have_http_status(404)
        end
      end
    end
  end

  describe 'POST #create' do
    let(:list_attributes) { attributes_for(:list, title: 'lista 3', description: 'descriptcion 3', state: 'true') }
    let(:list_attributes_bad) { attributes_for(:list, title: '', description: 'descriptcion 3', state: 'true') }

    context 'when user is not logged' do
      before do
        sign_out
        post :create, params: {list: list_attributes}
      end

      it 'returns 401 Http status code' do
        expect(response).to have_http_status(401)
      end
    end
    context 'when user is logged' do
      context 'with correct params' do
        before do
          sign_in @user
          post :create, params: {list: list_attributes}
        end

        it 'returns 201 Http status code' do
          expect(response).to have_http_status(201)
        end

        it 'returns correct information' do
          expect(data.keys).to include('id',
                                       'title',
                                       'description',
                                       'state',
                                       'user_id',
                                       'created_at',
                                       'updated_at')
        end

        it 'returns correct data' do
          expect(data['title']).to eq(list_attributes[:title])
          expect(data['description']).to eq(list_attributes[:description])
          expect(data['state'].to_s).to eq(list_attributes[:state])
          expect(data['user_id'].to_s).to eq(@id)
        end
      end

      context 'with incorrect params' do
        before do
          sign_in @user
          post :create, params: {list: list_attributes_bad}
        end

        it 'returns 422 Http status code' do
          expect(response).to have_http_status(422)
        end

        it 'body has an ActiveModel error' do
          expect(data).to eq("title"=>[{"error"=>"blank"}])
        end
      end
    end
  end

  describe 'PUT #update' do
    let(:list_attributes) { attributes_for(:list, title: 'lista_new', description: 'descriptcion new') }
    let(:bad_list_attributes) { attributes_for(:list, title: '', description: 'descriptcion new') }

    context 'when user is not logged' do
      before do
        sign_out
        put :update, params: {id: 1, list: list_attributes}
      end

      it 'returns 401 Http status code' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is logged' do
      context 'with correct params' do
        before do
          sign_in @user
          put :update, params: {id: 1, list: list_attributes}
        end

        it 'returns 204 Http status code' do
          expect(response).to have_http_status(204)
        end

        it 'returns the correct information (empty)' do
          expect(response.body).to be_empty
        end
      end

      context 'when list dont exist' do
        before do
          sign_in @user
          put :update, params: {id: 1859, list: list_attributes}
        end

        it 'returns 404 Http status code' do
          expect(response).to have_http_status(404)
        end
      end

      context 'when user is not authorized' do
        before do
          sign_in @user
          put :update, params: {id: 2, list: list_attributes}
        end

        it 'returns 403 Http status code' do
          expect(response).to have_http_status(403)
        end

        it 'do not update list' do
          @list_before_updated = @list
          @list.reload
          expect(@list).to eq(@list_before_updated)
        end
      end

      context 'with incorrect params' do
        before do
          sign_in @user
          post :create, params: {id: 2, list: bad_list_attributes }
        end

        it 'returns 422 Http status code' do
          expect(response).to have_http_status(422)
        end

        it 'body has an ActiveModel error' do
          expect(data).to eq("title"=>[{"error"=>"blank"}])
        end

        it 'do not update list' do
          @list_before_updated = @list
          @list.reload
          expect(@list).to eq(@list_before_updated)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is not logged' do
      before do
        sign_out
        delete :destroy, params: {id: 1}
      end

      it 'returns 401 Http status code' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is logged' do
      context 'with correct params' do
        before do
          sign_in @user
          delete :destroy, params: {id: @list['id']}
        end

        it 'returns 204 Http status code' do
          expect(response).to have_http_status(204)
        end

        it 'returns the correct information (empty)' do
          expect(response.body).to be_empty
        end
      end

      context 'when list dont exist' do
        before do
          sign_in @user
          delete :destroy, params: {id: 1589}
        end

        it 'returns 404 Http status code' do
          expect(response).to have_http_status(404)
        end
      end

      context 'when user is not authorized' do
        before do
          sign_in @user
          delete :destroy, params: {id: @list2['id']}
        end

        it 'returns 403 Http status code' do
          expect(response).to have_http_status(403)
        end

        it 'dont delete list' do
          expect { delete :destroy, params: {id: @list2['id']} }.to change(List, :count).by(0)
        end
      end
    end
  end
end
