# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Notice, :type => :model do
  it "should use Factory" do
      notice = FactoryGirl.create(:notice)
      expect(notice.text).to be_present
      expect(notice.user).to be_present
  end

  it "should has correct spaces" do
    str_size_30 = "123456789012345678901234567890"
    str_size_31 = "1234567890123456789012345678901"
    str_size_longer_30_with_space = "12345678901234567 89012345678901"
    notice_text_30 = FactoryGirl.create(:notice, :text => str_size_30)
    notice_text_31 = FactoryGirl.create(:notice, :text => str_size_31)
    notice_text_longer_30_with_space = FactoryGirl.create(:notice, :text => str_size_longer_30_with_space)
    expect(notice_text_30.correct_spaces?).to be_truthy
    expect(notice_text_31.correct_spaces?).to be_falsey
    expect(notice_text_longer_30_with_space.correct_spaces?).to be_truthy
  end
end
