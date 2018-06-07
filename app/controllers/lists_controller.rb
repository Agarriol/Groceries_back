class ListsController < ApplicationController
  before_action :set_list, only: %i[show update destroy]
  before_action :authenticate!

  # GET /lists
  def index
    @lists = List.all
                 .filter(filter_params)
                 .orderly(params, order_params)
                 .paginate(params)

    render json: {'data' => @lists.as_json(only: %i[id title description user_id state created_at]),
                  'meta' => {
                    'current_page' => @lists.current_page,
                    'total_pages' => @lists.total_pages,
                    'page_size' => @lists.size,
                    'total_elements' => @lists.total_count
                  }}
  end

  # GET /lists/1
  def show
    render json: @list.as_json(only: %i[id title description user_id state created_at])
  end

  # POST /lists
  def create
    # TODO, devolver solo los datos indicados
    @list = List.new(list_params)
    @list.user = current_user

    if @list.save
      render json: @list, status: :created, location: @list
    else
      render json: @list.errors.details, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lists/1
  def update
    authorize @list
    if @list.update(list_params)
      head '204'
    else
      render json: @list.errors.details, status: :unprocessable_entity
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

  def order_params
    %w[created_at title] # = ['created_at', 'title']
  end

  def filter_params
    params[:filter]&.permit(:title, :description) || {}
    # Otra opción: params[:filter]&.slice(:title, :description) || {}
    # Es peor por qué puede lanzar un error  ActiveModel::ForbiddenAtributes (o eso dicen)
  end
end
