module Pageable
  def paginate(params)
    return page(1).per(10) unless params[:page]

    @page = params[:page]

    if @page[:size]
      @page[:size] = '10' if @page[:size] <= '0'
    end

    page(@page[:number] || 1).per(@page[:size] || 10)
  end
end
