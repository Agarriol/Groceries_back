class ItemsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]
  before_action :authenticate!

  # GET /items
  def index
    # @items = Item.all
    @items = List.find(params[:list_id]).items.all.select('id', 'name', 'price', 'list_id', 'user_id', 'created_at')

    orderly

    @page = params[:page] || {} if defined?(params[:page])

    @items = @items.order(@sort => @sort_order)
                   .page(@page[:number] || 1)
                   .per(@page[:size] || 10)

    render json: {'data' => @items.as_json(include: :votes),
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

      @new_item = {}
      @new_item['id'] = @item.id
      @new_item['name'] = @item.name
      @new_item['price'] = @item.price
      @new_item['list_id'] = @item.list_id
      @new_item['created_at'] = @item.created_at

      render json: @new_item, status: :created # , location: @list.items
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1
  def update
    authorize @item
    if @item.update(item_params)
      head '204'
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /items/1
  def destroy
    authorize @item

    @item.votes.each(&:destroy)
    # @item.votes.each do |p|
    #   p.destroy
    # end

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

  # TODO, función generica para ordenar... en list y en items
  def orderly
    @sort = params[:sort] || 'id'

    @sort_order = if @sort[0] == '-'
                    :desc
                  else
                    :asc
                  end

    @sort = @sort.sub(/-/, '')

    @sort = if ['created_at', 'id'].include? @sort # if @sort == 'created_at' || @sort == 'id'
              @sort
            else
              'id'
            end
  end
end
