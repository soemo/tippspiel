require 'rails_helper'

describe Notes::Create do

  subject { Notes::Create }

  let(:user) {create :user}
  let(:max_long_word) { 'a' * Notice::MAX_SIZE_WITHOUT_SPACES }

  before :each do
    expect(Notice.count).to eq(0)
  end

  it 'add notice' do
    error_msg = subject.call(notice_text: max_long_word, current_user_id: user.id)
    expect(error_msg).to eq('')
    expect(Notice.count).to eq(1)
  end

  it 'does not save notice, if no text present' do
    error_msg = subject.call(notice_text: '', current_user_id: user.id)
    expect(error_msg).to eq(I18n.t(:notice_needs_a_comment))
    expect(Notice.count).to eq(0)
  end

  it 'does not save notice, if to long word without spaces' do
    too_long_word_without_spaces = max_long_word + 'b'
    error_msg = subject.call(notice_text: too_long_word_without_spaces, current_user_id: user.id)
    expect(error_msg).to eq(I18n.t(:notice_needs_spaces))
    expect(Notice.count).to eq(0)
  end

  it 'does not save notice, if text longer then 200' do
    longer_then_max = ('w' * 100) + ' ' + ('b' * 100)
    error_msg = subject.call(notice_text: longer_then_max, current_user_id: user.id)
    expect(error_msg).to eq("Text ist zu lang (nicht mehr als #{Notice::MAX_SIZE} Zeichen)")
    expect(Notice.count).to eq(0)
  end

  context '#correct_spaces?' do
    it 'has correct spaces string 100' do
      str_size_100 = 'a' * Notice::MAX_SIZE_WITHOUT_SPACES
      error_msg = subject.call(notice_text: str_size_100, current_user_id: user.id)
      expect(error_msg).to eq('')
    end

    it 'has not correct spaces string 101' do
      str_size_101 = ('a' * Notice::MAX_SIZE_WITHOUT_SPACES) + 'b'
      error_msg = subject.call(notice_text: str_size_101, current_user_id: user.id)
      expect(error_msg).to eq(I18n.t(:notice_needs_spaces))
    end

    it 'has correct spaces string longer 100 with spaces' do
      str_size_longer_100_with_space = "1234567890123456789012345678901234567890123456789012345678901234567890 123456789012345678901234567 89012345678901"
      error_msg = subject.call(notice_text: str_size_longer_100_with_space, current_user_id: user.id)
      expect(error_msg).to eq('')
    end
  end


end