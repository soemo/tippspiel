require 'rails_helper'

describe RankingPerGameShowPresenter do

  subject { RankingPerGameShowPresenter }

  let(:chart_x_labels) {['Label1', 'Label2', 'Label3']}

  let(:user_rankings) {[4,2,1]}


  context '#chart_data' do

    it 'returns chart_data' do
      presenter = subject.new(user_rankings, chart_x_labels)

      expect(presenter.chart_data).to eq(
                                          {
                                              labels: ['Label1', 'Label2', 'Label3'],
                                              datasets: [

                                                  {
                                                      label: I18n.t(:your_ranking_per_game),
                                                      fillColor: "rgba(151,187,205,0.2)",
                                                      strokeColor: "rgba(151,187,205,1)",
                                                      pointColor: "rgba(151,187,205,1)",
                                                      pointStrokeColor: "#fff",
                                                      pointHighlightFill: "#fff",
                                                      pointHighlightStroke: "rgba(151,187,205,1)",
                                                      data: [4,2,1]
                                                  }
                                              ]
                                          }
                                      )
    end
  end

  context '#chart_options' do

    it 'returns chart_options' do
      presenter = subject.new(user_rankings, chart_x_labels)

      expect(presenter.chart_options).to eq(
                                             {
                                                 responsive: true,
                                                 bezierCurve: true,
                                                 scaleOverride: true,
                                                 scaleSteps: 3,
                                                 scaleStepWidth: -1,
                                                 scaleStartValue: 4,
                                                 showTooltips: false
                                             }
                                         )
    end
  end

  context '#has_chart_data_to_show?' do

    context 'if user_rankings present?' do
      it 'returns true' do
        presenter = subject.new(user_rankings, chart_x_labels)
        expect(presenter.has_chart_data_to_show?).to be true

        presenter = subject.new([nil, 1], chart_x_labels)
        expect(presenter.has_chart_data_to_show?).to be true
      end
    end

    context 'if user_rankings not present?' do
      it 'returns false' do
        presenter = subject.new([], chart_x_labels)
        expect(presenter.has_chart_data_to_show?).to be false

        presenter = subject.new(nil, chart_x_labels)
        expect(presenter.has_chart_data_to_show?).to be false

        presenter = subject.new([nil, '', nil], chart_x_labels)
        expect(presenter.has_chart_data_to_show?).to be false
      end
    end
  end
end