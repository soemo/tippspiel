require 'rails_helper'

describe HelpPresenter do

  subject { HelpPresenter.new() }

  describe '#round_infos' do
    before :each do
      stub_const('ROUNDS', [GROUP, ROUND_OF_16, FINAL])
    end

    it 'return Round info array' do
      one_month_ago = DateTime.now - 1.month
      two_week_ago = DateTime.now - 2.week
      one_week_ago = DateTime.now - 1.week
      four_days_ago = DateTime.now - 4.days
      two_days_ago = DateTime.now - 2.days

      expect(Tournament).to receive(:round_start_end_date_time).
        with(GROUP).ordered.and_return([one_month_ago, two_week_ago])
      expect(Tournament).to receive(:round_start_end_date_time).
        with(ROUND_OF_16).ordered.and_return([one_week_ago, four_days_ago])
      expect(Tournament).to receive(:round_start_end_date_time).
        with(FINAL).ordered.and_return([two_days_ago, two_days_ago])

      expected = [
        "#{I18n.l(one_month_ago, format: :only_date)} - #{I18n.l(two_week_ago, format: :only_date)}: Gruppe",
        "#{I18n.l(one_week_ago, format: :only_date)} - #{I18n.l(four_days_ago, format: :only_date)}: Achtelfinale",
        "#{I18n.l(two_days_ago, format: :only_date)}: Finale",
      ]
      expect(subject.round_infos).to eq(expected)
    end
  end
end
