require 'spec_helper'

describe User do
  describe 'confirm_with_max_time!' do
    it 'should call normal confirmation routine, if confirmation is in time' do
      u = User.new
      u.confirmation_sent_at = 1.hour.ago
      u.should_receive(:confirm_without_maximum_time!).and_return(true)
      u.confirm!
    end

    it 'should add an error, if confirmation is too old' do
      u = User.new
      u.confirmation_sent_at = 25.hour.ago
      u.should_not_receive(:confirm_without_maximum_time!)
      u.confirm!
      u.errors[:base].should_not be_empty
    end
  end
end
