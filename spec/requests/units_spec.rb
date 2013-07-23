require 'spec_helper'

describe "Units" do

  subject { page }

  describe "Root Page" do
    before { visit units_path }

    it { should have_selector('a#logo', text: 'Choice Object') }
    it { should have_selector('title', text: '| Home') }

  end

end
