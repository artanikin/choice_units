class UnitsController < ApplicationController 

  # TODO: 1. Рассмотреть альтернативные методы задания настроек
  POSSIBLE_AGE    = [0, 100]
  POSSIBLE_SALARY = [0, 1000000]
  POSSIBLE_GROWTH = [0, 200]
  POSSIBLE_WEIGHT = [0, 200]

  def index
    # TODO: 1. Убрать весь шум
    params[:age] =    { start: '20',    stop: '26'     }
    params[:salary] = { start: '1000', stop: '70000' }
    params[:growth] = { start: '0',   stop: '220'    }
    params[:weight] = { start: '0',    stop: '200'     }

    @conditions = get_filter_array_conditions(params)
    @conditions.sort_by! { |k|k[1][2] }
    sql = get_sql_conditions(@conditions)
    @print = sql.join(' AND ')
    @test_data = get_integer_params(POSSIBLE_AGE, params[:age])
    @units = Unit.filter(sql)
  end

  private
    # TODO: 1. Слишком много переменных с похожими названиями
    # TODO: 2. По возмжности сократить длинные названия переменнных
    # TODO: 3. Попытаться упаковать все методы в отдельный класс

    def get_filter_array_conditions(params)
      # TODO: 1. Убрать жесткую привязку к данным
      filter_conditions = {}
      filter_conditions[:age]    = get_filter_condition(POSSIBLE_AGE,    params[:age]) if params[:age]
      filter_conditions[:salary] = get_filter_condition(POSSIBLE_SALARY, params[:salary]) if params[:salary]
      filter_conditions[:growth] = get_filter_condition(POSSIBLE_GROWTH, params[:growth]) if params[:growth]
      filter_conditions[:weight] = get_filter_condition(POSSIBLE_WEIGHT, params[:weight]) if params[:weight]
      filter_conditions.to_a
    end

    def get_filter_condition(possible_values, params)
      condition = get_filtered_data(possible_values, params)
      percent = get_percentage_entering_values_in_range(possible_values, condition)
      condition << percent
    end

    def get_sql_conditions(conditions)
      # TODO: 1. Изменить способ вытаскивания данных из переменной 
      # conditions.
      # TODO: 2. Изменить данные, которые получает метод
      sql_conditions = []
      conditions.each do |condition|
        column = condition[0]
        start  = condition[1][0]
        stop   = condition[1][1]
        percent  = condition[1][2]

        sql_conditions << "#{column} BETWEEN #{start} AND #{stop}" unless percent == 100
      end
      sql_conditions
    end

    def get_percentage_entering_values_in_range(possible_values, input_params)
      (input_params.last - input_params.first)*100.0 / (possible_values.last - possible_values.first)
    end

    def get_filtered_data(possible_values, input_params)
      input_int_param = get_integer_params(possible_values, input_params)
      filtered_data = get_value_in_possible_range(possible_values, input_int_param)
    end

    def get_integer_params(possible_values, input_params)
      # TODO: 1. Нужно получить параметр введенного диапозона
      # в виде целого значения
      input_params[:start] = possible_values.first unless input_params[:start].is_integer?
      input_params[:stop]  = possible_values.last  unless input_params[:stop].is_integer?
      input_params
    end

    def get_value_in_possible_range(possible_values, input_params)
      # TODO: 1. Убрать преобразования в целое (метод to_i)
      result_values = []
      range_possible_values = possible_values.first..possible_values.last

      input_params.each do |key, value|
        value = value.to_i
        unless range_possible_values.include? value.to_i
            value = if value < possible_values.first
              possible_values.first
            else
              possible_values.last
            end
        end
        result_values << value 
      end
      result_values.sort!
    end



  # def filtering
    
    

  #   @units = Unit.where('age BETWEEN ? AND ?', 0, 100)
  #   render action: :index
  # end

  # def filtering
  #   # TODO: 1. Проверить что параметры существуют

  #   @params = params.keys

  #   filter_age    = params[:age_from]    + params[:age_to]
  #   filter_salary = params[:salary_from] + params[:salary_to]
  #   filter_growth = params[:growth_from] + params[:growth_to]
  #   filter_weight = params[:weight_from] + params[:weight_to]
    
  #   @age    = get_filter_values_for_column(POSSIBLE_AGE,    filter_age)
  #   @salary = get_filter_values_for_column(POSSIBLE_SALARY, filter_salary)
  #   @growth = get_filter_values_for_column(POSSIBLE_GROWTH, filter_growth)
  #   @weight = get_filter_values_for_column(POSSIBLE_WEIGHT, filter_weight)

  #   @sql_conditions = []
  #   @sql_conditions << get_condition_in_sql_string('age', @age) if @age
  #   @sql_conditions << get_condition_in_sql_string('salary', @salary) if @salary
  #   @sql_conditions << get_condition_in_sql_string('growth', @growth) if @growth
  #   @sql_conditions << get_condition_in_sql_string('weight', @weight) if @weight

  #   @units = Unit.where(@sql_conditions.join(' AND '))

  #   render action: :index
  # end

  # private

  #   def get_condition_in_sql_string(column, params)
  #     "#{column} BETWEEN #{params[0]} AND #{params[1]}"
  #   end

  #   def get_filter_values_for_column(possible_values, params)

  #     params = get_params_if_empty(possible_values, params)
  #     params = get_params_if_integer(possible_values, params)
  #     params = get_params_if_include_in_possible_values(possible_values, params)

  #     return false if possible_values == params
  #     params
  #   end


  #   def get_params_if_empty(possible_values, params)
  #     for i in 0..params.count-1
  #       params[i] = possible_values[i] if params[i].empty?  
  #     end
  #     params      
  #   end


  #   def get_params_if_integer(possible_values, params)
  #     result_values = []
  #     for i in 0..params.count - 1
  #       result_values << if params[i].is_integer?
  #         params[i].to_i 
  #       else
  #         possible_values[i]
  #       end
  #     end
  #     result_values
  #   end


  #   def get_params_if_include_in_possible_values(possible_values, params)
  #     result_values = []
  #     possible_values_range = possible_values.first..possible_values.last
  #     params_count_range = 0..params.count - 1

  #     for i in params_count_range
  #       result_values << if possible_values_range.include? params[i]
  #         params[i] 
  #       else
  #         possible_values[i]
  #       end
  #     end
  #     result_values.sort!
  #   end


end
