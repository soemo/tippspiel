# -*- encoding : utf-8 -*-
require 'spec_helper'

describe SchedulerController do
  render_views

  before :each do

    @mock_json_data = {"leagueID" => 107,
                       "is_tournament" => true,
                       "timestamp" => "2012-04-27 17:31:50",
                       "matches" => []}.to_json

  end

  describe "should work without login" do
    test_scheduler_actions.each do |action|
      it "should get #{action}" do
        setup_net_mock(@mock_json_data, ResultGrabber::RESULT_URL_EM2012)
        get action
        response.should be_success
      end
    end
  end

  describe "schould not run that often" do
    test_scheduler_actions.each do |action|
      it "should get #{action}" do
        setup_net_mock(@mock_json_data, ResultGrabber::RESULT_URL_EM2012)
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

  private

  def setup_net_mock(data, url, content_type = "text/plain")
    stub_http_request(:get, url).to_return(:body => data, :status => 200,
                                      :headers => {:content_type => content_type})
  end

end
