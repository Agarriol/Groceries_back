class ListsController < ApplicationController
  before_action :set_list, only: %i[show update destroy]
  before_action :authenticate!

  # GET /lists
  def index
    @lists = List.all.select('id', 'title', 'description','user_id', 'created_at')

    filter if params[:filter] # TODO, ¿por qué no defined?()
    orderly
    @page = params[:page] || {} if defined?(params[:page])

    @lists = @lists.order(@sort => @sort_order)
                   .page(@page[:number] || 1)
                   .per(@page[:size] || 10)

    render json: {'data' => @lists,
                  'meta' => {
                    'current_page' => @lists.current_page,
                    'total_pages' => @lists.total_pages,
                    'page_size' => @lists.size,
                    'total_elements' => @lists.total_count
                  }}
  end

  # GET /lists/1
  def show
    @list_show = List.select('id', 'title', 'description', 'user_id', 'created_at').find(params[:id])

    render json: @list_show
  end

  # POST /lists
  def create
    # TODO, devolver solo los datos indicados
    @list = List.new(list_params)
    @list.user = current_user

    if @list.save
      render json: @list, status: :created, location: @list
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lists/1
  def update
    authorize @list
    if @list.update(list_params)
      head '204'
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  # DELETE /lists/1
  def destroy
    authorize @list
    @list.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_list
    @list = List.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def list_params
    params.require(:list).permit(:title, :description, :state, :user_id)
  end

  # TODO, función paginación
  # def paginate
  #   page(params[:page][:number] || 1).per(params[:page][:size] || 10)
  # end

  def filter
    @lists = @lists.where(title: params[:filter][:title]) if params[:filter][:title]
  end

  def orderly
    @sort = params[:sort] || 'id'

    @sort_order = if @sort[0] == '-'
                    :desc
                  else
                    :asc
                  end

    @sort = @sort.sub(/-/, '')

    @sort = if ['title', 'created_at', 'id'].include? @sort # if @sort == 'title' || @sort == 'created_at' || @sort == 'id'
              @sort
            else
              'id'
            end
  end
end
