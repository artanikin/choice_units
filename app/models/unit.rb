class Unit < ActiveRecord::Base
  attr_accessible :age, :salary, :growth, :weight
  self.per_page = 20

  # Возвращает отфильтрованные значения, по принятым условаиям 
  def self.filter_by(conditions)
    sql_conditions = get_sql_conditions(conditions).join(" AND ")
    self.where(sql_conditions)
  end

  private

    # Формирует условия в виде SQL строк
    def self.get_sql_conditions(conditions)
      sql_conditions = []
      conditions.each do |column, value_range|
        unless value_range['percent'] == 100
          start = value_range['start']
          stop  = value_range['stop']
          sql = "#{column} BETWEEN #{start} AND #{stop}"
          sql_conditions << sql
        end
      end
      sql_conditions
    end
end
