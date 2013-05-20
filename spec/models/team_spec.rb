# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Team do
  it "should use Factory" do
      team = FactoryGirl.create(:team)
      team.name.should be_present
  end
end
