require 'rails_helper'

describe RankingPerGameShowPresenter do

  subject { RankingPerGameShowPresenter }

  let(:chart_x_labels) {['Label1', 'Label2', 'Label3']}

  let(:user_rankings) {[4,2,1]}
  let(:games) {[Game.new, Game.new, Game.new]}


  context '#chart_data' do

    it 'returns chart_data' do
      presenter = subject.new(user_rankings, games)
      expect(presenter).to receive(:chart_x_labels).and_return(chart_x_labels)

      expect(presenter.chart_data).to eq(
                                          {
                                              labels: ['Label1', 'Label2', 'Label3'],
                                              datasets: [
                                                  {
                                                      label: I18n.t(:your_ranking_per_game),
                                                      fill: false,
                                                      borderColor: "rgba(75,192,192,1)",
                                                      pointBorderColor: "rgba(75,192,192,1)",
                                                      pointBackgroundColor: "#fff",
                                                      pointHoverBackgroundColor: "rgba(75,192,192,1)",
                                                      pointHoverBorderColor: "rgba(220,220,220,1)",
                                                      data: [4,2,1]
                                                  }
                                              ]
                                          }
                                      )
    end
  end

  context '#chart_options' do

    it 'returns chart_options' do
      presenter = subject.new(user_rankings, games)

      expect(presenter.chart_options).to eq(
                                             {
                                                 legend: {
                                                     position: 'bottom'
                                                 },
                                                 responsive: true,
                                                 scales: {
                                                     xAxes: [
                                                         {
                                                             display: false
                                                         }
                                                     ],
                                                     yAxes: [
                                                         {
                                                             ticks: {
                                                                 reverse: true
                                                             }
                                                         }
                                                     ]
                                                 },
                                             }
                                         )
    end
  end

  context '#has_chart_data_to_show?' do

    context 'if user_rankings present?' do
      it 'returns true' do
        presenter = subject.new(user_rankings, games)
        expect(presenter.has_chart_data_to_show?).to be true

        presenter = subject.new([nil, 1], games)
        expect(presenter.has_chart_data_to_show?).to be true
      end
    end

    context 'if user_rankings not present?' do
      it 'returns false' do
        presenter = subject.new([], games)
        expect(presenter.has_chart_data_to_show?).to be false

        presenter = subject.new(nil, games)
        expect(presenter.has_chart_data_to_show?).to be false

        presenter = subject.new([nil, '', nil], chart_x_labels)
        expect(presenter.has_chart_data_to_show?).to be false
      end
    end
  end
end