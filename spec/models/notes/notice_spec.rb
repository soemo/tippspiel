# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Notice, :type => :model do
  it 'uses Factory' do
      notice = FactoryGirl.create(:notice)
      expect(notice.text).to be_present
      expect(notice.user).to be_present
  end

end
