module Orderable
  def orderly(params, order_params)
    return order('') unless params[:sort]

    fields = params[:sort].split(',')

    i = 0
    field = {}
    sort_order = {}

    while i < fields.length
      fields[i] = fields[i].sub(' ', '')

      field[i] = fields[i].sub(/-/, '')

      sort_order[i] = if fields[i][0] == '-'
                        'desc'
                      else
                        'asc'
                      end

      result = "#{result}, #{field[i]} #{sort_order[i]}" if order_params.include? field[i]
      # order_params.include? field[i] es igual que
      # if field[i] == order_params[0] || field[i] == order_params[1]...

      i += 1
    end

    result[0] = '' if result

    order(result)
  end
end
