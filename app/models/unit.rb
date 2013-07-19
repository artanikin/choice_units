class Unit < ActiveRecord::Base
  attr_accessible :age, :salary, :growth, :weight

  def self.filter(conditions)
    # TODO 1. Если диапозон равен max и min значениям, тогда убрать
    # из запроса
    string = conditions.join(' AND ')
    self.where(string)
  end
end
