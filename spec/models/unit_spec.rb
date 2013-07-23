require 'spec_helper'

describe Unit do
  
  before { @unit = Unit.new(age: 55, salary: 30000, growth: 184, weight: 84) }

  subject { @unit }

  it { should respond_to(:age)    }
  it { should respond_to(:salary) }
  it { should respond_to(:growth) }
  it { should respond_to(:weight) }

end
