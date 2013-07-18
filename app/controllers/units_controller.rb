class UnitsController < ApplicationController

  POSSIBLE_AGE    = [0, 100]
  POSSIBLE_SALARY = [0, 1000000]
  POSSIBLE_GROWTH = [0, 200]
  POSSIBLE_WEIGHT = [0, 200]

  def index
    @units = Unit.all
  end


  def filtering
    # TODO: 1. Проверить что параметры существуют

    @params = params.keys

    filter_age    = params[:age_from]    + params[:age_to]
    filter_salary = params[:salary_from] + params[:salary_to]
    filter_growth = params[:growth_from] + params[:growth_to]
    filter_weight = params[:weight_from] + params[:weight_to]
    
    @age    = get_filter_values_for_column(POSSIBLE_AGE,    filter_age)
    @salary = get_filter_values_for_column(POSSIBLE_SALARY, filter_salary)
    @growth = get_filter_values_for_column(POSSIBLE_GROWTH, filter_growth)
    @weight = get_filter_values_for_column(POSSIBLE_WEIGHT, filter_weight)

    @sql_conditions = []
    @sql_conditions << get_condition_in_sql_string('age', @age) if @age
    @sql_conditions << get_condition_in_sql_string('salary', @salary) if @salary
    @sql_conditions << get_condition_in_sql_string('growth', @growth) if @growth
    @sql_conditions << get_condition_in_sql_string('weight', @weight) if @weight

    @units = Unit.where(@sql_conditions.join(' AND '))

    render action: :index
  end

  private

    def get_condition_in_sql_string(column, params)
      "#{column} BETWEEN #{params[0]} AND #{params[1]}"
    end

    def get_filter_values_for_column(possible_values, params)

      params = get_params_if_empty(possible_values, params)
      params = get_params_if_integer(possible_values, params)
      params = get_params_if_include_in_possible_values(possible_values, params)

      return false if possible_values == params
      params
    end


    def get_params_if_empty(possible_values, params)
      for i in 0..params.count-1
        params[i] = possible_values[i] if params[i].empty?  
      end
      params      
    end


    def get_params_if_integer(possible_values, params)
      result_values = []
      for i in 0..params.count - 1
        result_values << if params[i].is_integer?
          params[i].to_i 
        else
          possible_values[i]
        end
      end
      result_values
    end


    def get_params_if_include_in_possible_values(possible_values, params)
      result_values = []
      possible_values_range = possible_values.first..possible_values.last
      params_count_range = 0..params.count - 1

      for i in params_count_range
        result_values << if possible_values_range.include? params[i]
          params[i] 
        else
          possible_values[i]
        end
      end
      result_values.sort!
    end


end
