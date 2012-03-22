require 'spec_helper'

describe Notice do
  it "should use Factory" do
      notice = Factory(:notice)
      notice.text.should be_present
      notice.user.should be_present
  end
end
