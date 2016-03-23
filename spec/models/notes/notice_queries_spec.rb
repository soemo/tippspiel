require 'rails_helper'

describe NoticeQueries do

  subject { NoticeQueries }

  context '#order_by_created_at_asc' do
    it 'returns with correct order' do
      Timecop.freeze(Time.now)
      notice1 = create(:notice)
      notice2 = create(:notice)
      notice3 = create(:notice)
      notice1.update_column(:created_at, Time.now - 5.minutes)
      notice2.update_column(:created_at, Time.now - 6.minutes)
      notice3.update_column(:created_at, Time.now - 1.minutes)

      result = subject.order_by_created_at_asc
      expect(result.to_a).to eq([notice3, notice1, notice2])
    end
  end

end