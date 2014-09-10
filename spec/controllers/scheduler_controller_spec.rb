# -*- encoding : utf-8 -*-
require 'rails_helper'

describe SchedulerController, :type => :controller do
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
        setup_net_mock(@mock_json_data, RESULT_URL)
        get action
        expect(response).to be_success
      end
    end
  end

  describe "schould not run that often" do
    test_scheduler_actions.each do |action|
      it "should get #{action}" do
        setup_net_mock(@mock_json_data, RESULT_URL)
        get action
        expect(response).to be_success
        get action
        if action == "admin"
          expect(response).to be_success
        else
          expect(response.response_code).to eq(400)
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
