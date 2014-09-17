# -*- encoding : utf-8 -*-
require 'rails_helper'

describe SchedulerController, :type => :routing do

  describe "routing" do
    test_scheduler_actions.each do |action|
      it "routes to #{action}" do
        assert_recognizes({ :controller => "scheduler", :action => action}, "/scheduler/#{action}")
      end
    end
  end

end
