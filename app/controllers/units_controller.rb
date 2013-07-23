class UnitsController < ApplicationController 

  def index
    @input_values = set_default_values
    @units = Unit.paginate(page: params[:page])
  end


  def filtered
    possible_values = set_possible_values
    @input_values = get_input_values(params)

    filter = Filter.new(possible_values, @input_values)
    filtered_data = filter.get_filtered_data

    @units = Unit.filter_by(filtered_data).paginate(page: params[:page])
    render 'index'
  end


  private

    # Устанавливает фильтру значения по умолчанию
    def set_default_values
      values = set_possible_values
      default_range = { start: '', stop: '' }
      values.each { |column, range| values[column] = default_range }
      values
    end


    # Устнавливает диапазон фозможных значений для фильтра
    def set_possible_values
      possible_values = { 
        age:    { start: 0, stop: 100     },
        salary: { start: 0, stop: 1000000 },
        growth: { start: 0, stop: 200     },
        weight: { start: 0, stop: 200     } }
    end


    # Получает диапазоны значений для фильтрации данных из
    # параметров, принятых из GET запроса. 
    # Для параметров, диапазоны которых небыли введены, 
    # устанавливает заглушку
    def get_input_values(params)
      possible_column = set_possible_values.keys
      input_values = {}

      possible_column.each do |column|
        if params[column]
          input_values[column] = params[column]  
        else
          input_values[column] = { start: '', stop: '' }
        end
      end
      input_values
    end
end