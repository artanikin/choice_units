class UnitsController < ApplicationController 

  def index

    params[:age] =    { start: '20',    stop: '26'     }
    params[:salary] = { start: '1000', stop: '7000000' }
    params[:growth] = { start: '0',   stop: '220.4'    }
    params[:weight] = { start: '80',    stop: '100'     }


    possible_values = { age:    { start: 0, stop: 100 },
                        salary: { start: 0, stop: 1000000 },
                        growth: { start: 0, stop: 200 },
                        weight: { start: 0, stop: 200 } }
    input_values = {}
    input_values[:age]    = params[:age]    if params[:age]
    input_values[:salary] = params[:salary] if params[:salary]
    input_values[:growth] = params[:growth] if params[:growth]
    input_values[:weight] = params[:weight] if params[:weight]

    filter = Filter2.new(possible_values, input_values)
    filtered_data = filter.get_filtered_data
    @units = Unit.filter(filtered_data)
  end

 
end

class Filter2

  def initialize(possible_values, input_values)
    @possible_values = possible_values
    @input_values    = input_values
  end


  def get_filtered_data
    set_string_values_to_integer!
    set_value_in_possible_range!
    get_sorted_data_by_percentage
  end


  private

    def get_sorted_data_by_percentage
      set_percentage_entering_values_in_range!
      sort_data_by_percentage
    end


    def set_percentage_entering_values_in_range!
      @input_values.each do |column, value_range|  
        difference_entered_values  = value_range['stop'] - value_range['start']
        difference_possible_values = @possible_values[column][:stop] - @possible_values[column][:start]
        @input_values[column]['percent'] = difference_entered_values*100.0 / difference_possible_values
      end
      @input_values
    end


    def sort_data_by_percentage
      @input_values.sort_by { |column, value_range| value_range['percent'] }
    end


    def set_string_values_to_integer!
      result_values = {}

      @input_values.each do |column, value_range|
        range_column = {}

        value_range.each do |key, value|
          if value.is_integer?
            range_column[key] = value.to_f.round
          else
            range_column[key] = @possible_values[column][key]
          end
          result_values[column] = range_column
        end
      end
      @input_values = result_values
    end


    def set_value_in_possible_range!
      result_values = {}

      @input_values.each do |column, value_range|
        range_possible_values = @possible_values[column][:start]..@possible_values[column][:stop]
        range_column = {}

        value_range.each do |key, value|
          unless range_possible_values.include? value
              range_column[key] = if value < range_possible_values.first
                range_possible_values.first
              else
                range_possible_values.last
              end
          else
            range_column[key] = value
          end
        end
        result_values[column] = sort_input_range(range_column)
      end
      @input_values = result_values
      end


    def sort_input_range(input_range)
      result = {}
      if input_range['start'] > input_range['stop']
        result['start'] = input_range['stop']
        result['stop']  = input_range['start']
      else
        result = input_range
      end
      result
    end

end
