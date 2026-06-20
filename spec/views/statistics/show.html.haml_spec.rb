# frozen_string_literal: true

require 'rails_helper'

describe 'statistics/show' do
  let(:presenter) { StatisticsShowPresenter.new(nil, nil, []) }

  let(:user_to_show) do
    build(:user,
          lastname: 'stats_user',
          points: 168,
          count8points: 6,
          count5points: 9,
          count4points: 3,
          count3points: 12,
          count0points: 9,
          bonus_points: 0)
  end

  def stub_common_presenter_methods
    allow(presenter).to receive_messages(
      header_text: I18n.t(:your_statistic),
      points_header_text: User.human_attribute_name('points'),
      total_points: 168,
      user_to_show: user_to_show,
      ranking_summary_header_text: 'Summary',
      ranking_current: 80, ranking_best: 51, ranking_worst: 101,
      ranking_current_date: '01.07.', ranking_best_date: '12.06.', ranking_worst_date: '15.06.',
      line_chart_header_text: 'Chart',
      tips_header_text: I18n.t(:tips),
      finished_tips: [],
      line_chart_data: { labels: [], datasets: [{}] },
      line_chart_options: { plugins: { tooltip: {} } }
    )
  end

  context 'when there is data to show' do
    before do
      allow(presenter).to receive(:data_to_show?).and_return(true)
      stub_common_presenter_methods
      assign(:presenter, presenter)
    end

    it 'shows the total points of the user' do
      render

      expect(rendered).to have_css('h4.statistic-points-header', text: User.human_attribute_name('points'))
      expect(rendered).to have_css('.statistic-points-summary span.user-points', text: '168')
    end

    it 'shows a point badge for every point category and the bonus' do
      render

      expect(rendered).to have_css('.statistic-points-summary span.badge', count: 6)
      expect(rendered).to have_css('.statistic-points-summary span.badge.eight-point-background-color', text: '6')
      expect(rendered).to have_css('.statistic-points-summary span.badge.five-point-background-color', text: '9')
      expect(rendered).to have_css('.statistic-points-summary span.badge.four-point-background-color', text: '3')
      expect(rendered).to have_css('.statistic-points-summary span.badge.three-point-background-color', text: '12')
      expect(rendered).to have_css('.statistic-points-summary span.badge.null-point-background-color', text: '9')
      expect(rendered).to have_css('.statistic-points-summary span.badge.badge-bonus', text: '0')
    end

    it 'shows the point legend' do
      render

      expect(rendered).to have_css('.point-explaining', count: 6)
    end
  end

  context 'when there is no data to show' do
    before do
      allow(presenter).to receive_messages(header_text: I18n.t(:your_statistic), data_to_show?: false)
      assign(:presenter, presenter)
    end

    it 'does not show the points summary' do
      render

      expect(rendered).to have_no_css('.statistic-points-summary')
      expect(rendered).to have_css('p', text: I18n.t(:ranking_per_game_nothing_to_show))
    end
  end
end
