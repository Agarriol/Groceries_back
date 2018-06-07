class ItemsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]
  before_action :authenticate!

  # GET /items
  def index
    @items = List.find(params[:list_id]).items.all
                 .orderly(params, order_params)
                 .paginate(params)

    render json: {'data' => @items.as_json(include: :votes, only: %i[id name price list_id user_id created_at]),
                  'meta' => {
                    'current_page' => @items.current_page,
                    'total_pages' => @items.total_pages,
                    'page_size' => @items.size,
                    'total_elements' => @items.total_count
                  }}
  end

  # POST /items
  def create
    @item = List.find(params[:list_id]).items.new(item_params)
    @item.user = current_user

    authorize @item

    if @item.save
      render json: @item.as_json(include: :votes, only: %i[id name price list_id created_at]), status: :created 
      # , location: @list.items
    else
      render json: @item.errors.details, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1
  def update
    authorize @item
    if @item.update(item_params)
      head '204'
    else
      render json: @item.errors.details, status: :unprocessable_entity
    end
  end

  # DELETE /items/1
  def destroy
    authorize @item

    @item.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def item_params
    params.require(:item).permit(:name, :price, :user_id)
  end

  def order_params
    %w[created_at id]
  end
end
