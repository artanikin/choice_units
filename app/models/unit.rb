class Unit < ActiveRecord::Base
  attr_accessible :age, :salary, :growth, :weight

  def self.filter(conditions)
    sql_conditions = get_sql_conditions(conditions)
    units = self
    sql_conditions.each do |sql|
      units = units.where(sql)
    end
    units
  end

  private

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
