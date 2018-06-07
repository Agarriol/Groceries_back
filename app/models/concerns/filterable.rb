module Filterable
  def filter_no_funciona(params)
    return where('') unless params
    where_key = ''
    where_value = ''

    params.each do |key,value|
      where_key = "#{where_key} AND #{key} LIKE ?"
      where_value = "#{where_value}, %#{value}%"
    end

    where_key[0..4] = ''
    where_value[0] = ''

    where("#{where_key},#{where_value}")
  end

  def filter(params)
    result = self

    params&.each { |key, value| result = result.send("by_#{key}", *value) }

    result
  end
end
