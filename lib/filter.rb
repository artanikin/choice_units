class Filter

  # Инициализация возможных и введенных значений 
  def initialize(possible_values, input_values)
    @possible_values = possible_values
    @input_values    = input_values
  end

  # Получает отфильтрованные данные
  def get_filtered_data
    input_values = set_integer_values(@input_values)
    input_values = get_correct_values(input_values)
    get_sorted_data_by_percentage(input_values)
  end


  private

    # Устанавливает целые значения в введенный диапазон
    # Восстанавливает цулостность диапазона
    def set_integer_values(input_values)
      result = {}
      input_values.each do |column, value_range|
        range_column = {}
        value_range.each do |key, value|
          range_column[key] = get_range_point(column, key, value)
          range_column = restores_integrity_data(@possible_values[column], range_column)
          result[column] = range_column
        end
      end
      result
    end

    # Получает точку диапазона, как целое число
    def get_range_point(column, key, value)
      if value.is_numeric?
        value.to_f.round
      else
        @possible_values[column][:"#{key}"]
      end
    end

    # Восстанавливает целостность диапазона, если он поврежден
    def restores_integrity_data(possible_values, value_range)
      possible_values.each do |key, value|
        unless value_range.has_key? "#{key}"
          value_range["#{key}"] = value
        end
      end
      value_range
    end


    # Получает корректные данные, попадающие в возможный
    # диапазон значений.
    def get_correct_values(input_values)
      result = {}

      input_values.each do |column, value_range|
        possible_range = get_possible_range(column)
        range_column = {}

        value_range.each { |key, value|
          range_column[key] = get_value_in_possible_range(possible_range, value) }

        result[column] = sort_input_range(range_column)
      end
      result
    end

    # Возвращает диапазон возможных значений для колонки
    def get_possible_range(column)
      @possible_values[column][:start]..@possible_values[column][:stop]
    end

    # Возвращает значение, попадающее в диапазон возможных
    def get_value_in_possible_range(possible_range, value)
      unless possible_range.include? value
        value = get_border_possible_values(possible_range, value)
      end
        value
    end

    # Получает границу возможного диапазона, взависимости от
    # введённого значения 
    def get_border_possible_values(possible_range, value)
      if value < possible_range.first
        possible_range.first
      else
        possible_range.last
      end
    end
    
    # Сортирует значения по ключам start и stop
    def sort_input_range(input_range)
      if input_range['start'] > input_range['stop']
        result = {}
        result['start'] = input_range['stop']
        result['stop']  = input_range['start']
        result
      else
        input_range
      end
    end
    

    # Получает отсортированные данные по проценту вхождения
    # введенных данных в возможный диапазон значений
    def get_sorted_data_by_percentage(input_values)
      input_values = set_percentage_entering_values_in_range(input_values)
      sort_data_by_percentage(input_values)
    end

    # Устанавливает процент вхождения введенных данных
    # в возможный диапазон значений
    def set_percentage_entering_values_in_range(input_values)
      input_values.each do |column, value_range|  
        difference_entered_values  = value_range['stop'] - value_range['start']
        difference_possible_values = @possible_values[column][:stop] - @possible_values[column][:start]
        input_values[column]['percent'] = difference_entered_values*100.0 / difference_possible_values
      end
      input_values
    end

    # Сортирует введенные значения по проценту вхождения в
    # возможный диапазон
    def sort_data_by_percentage(input_values)
      input_values.sort_by { |column, value_range| value_range['percent'] }
    end
end