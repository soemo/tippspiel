# frozen_string_literal: true

require 'rails_helper'

describe NoticeQueries do
  subject { described_class }

  describe '#order_by_created_at_asc' do
    it 'returns with correct order' do
      Timecop.freeze(Time.zone.now)
      notice1 = create(:notice)
      notice2 = create(:notice)
      notice3 = create(:notice)
      notice1.update_column(:created_at, 5.minutes.ago)
      notice2.update_column(:created_at, 6.minutes.ago)
      notice3.update_column(:created_at, 1.minute.ago)

      result = subject.order_by_created_at_asc
      expect(result.to_a).to eq([notice3, notice1, notice2])
    end
  end
end
