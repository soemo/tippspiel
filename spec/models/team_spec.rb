require 'spec_helper'

describe Team do
  it "should use Factory" do
      team = Factory(:team)
      team.name.should be_present
  end
end
