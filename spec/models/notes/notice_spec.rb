# frozen_string_literal: true

require 'rails_helper'

describe Notice do
  it 'uses Factory' do
    notice = create(:notice)
    expect(notice.text).to be_present
    expect(notice.user).to be_present
  end
end
