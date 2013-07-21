class Object
  def is_integer?
    true if Float(self) rescue false
  end
end