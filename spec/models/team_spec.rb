# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Team, :type => :model do
  it "should use Factory" do
      team = FactoryGirl.create(:team)
      expect(team.name).to be_present
  end
end
