class Filter

  def initialize(possible_values)
    @possible_values = possible_values
  end

  def greeter
    '@possible_values'
  end
end