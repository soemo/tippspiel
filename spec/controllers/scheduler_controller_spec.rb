require 'spec_helper'

describe SchedulerController do
  render_views

  describe "should work without login" do
    test_scheduler_actions.each do |action|
      it "should get #{action}" do
        get 'hourly'
        response.should be_success
      end
    end
  end

  describe "schould not run that often" do
    test_scheduler_actions.each do |action|
      it "should get #{action}" do
        get action
        response.should be_success
        get action
        if action == "admin"
          response.should be_success
        else
          response.response_code.should == 400
        end

      end
    end
  end


end
