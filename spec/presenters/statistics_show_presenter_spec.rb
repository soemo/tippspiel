require 'rails_helper'

describe StatisticsShowPresenter do

  subject { StatisticsShowPresenter }

  let(:line_chart_x_labels) {['Label1', 'Label2', 'Label3']}

  let(:current_user) {create(:user, firstname: 'active', lastname: 'user')}
  let(:user) {create(:user, firstname: 'test', lastname: 'user')}

  let(:user_rankings) {[4,2,1]}
  let(:games) {[Game.new(start_at: DateTime.now),
                Game.new(start_at: DateTime.now + 1.day),
                Game.new(start_at: DateTime.now + 2.day)]}

  describe '#user_to_show' do

    context 'if user to show == current_user' do

      it 'returns current_user' do
        presenter = subject.new(current_user, current_user.id, games)
        expect(presenter.user_to_show).to eq(current_user)
      end
    end

    context 'if user to show <> current_user' do

      it 'returns other user' do
        presenter = subject.new(current_user, user.id, games)
        expect(presenter.user_to_show).to eq(user)
      end
    end
  end

  describe '#shows_current_user_rankings?' do

    context 'if user_id is the current_user.id' do

      it 'returns true' do
        presenter = subject.new(current_user, current_user.id, games)
        expect(presenter.shows_current_user_rankings?).to be true
      end
    end

    context 'if user_id isnot  the current_user.id' do

      it 'returns false' do
        presenter = subject.new(current_user, user.id, games)
        expect(presenter.shows_current_user_rankings?).to be false
      end
    end
  end

  describe 'finished_tips' do

    it 'calls TipQueries.all_by_user_id_and_game_ids_ordered_games_start_at' do
      expect(TipQueries).to receive(:all_by_user_id_and_game_ids_ordered_games_start_at).
        with(user.id, games.map(&:id))

      presenter = subject.new(current_user, user.id, games)
      presenter.finished_tips
    end
  end

  describe '#user_ranking' do

    it 'calls TipQueries' do
      presenter = subject.new(current_user, user.id, games)

      tipp_query = double
      expect(presenter).to receive(:finished_tips).and_return(tipp_query)
      expect(tipp_query).to receive(:pluck).with(:ranking_place).and_return(user_rankings)

      expect(presenter.user_rankings).to eq(user_rankings)
    end
  end

  describe '#header_text' do

    context 'if ranking for current_user' do

      it 'returns text for current_user' do
        presenter = subject.new(current_user, current_user.id, games)
        expect(presenter.header_text).to eq(I18n.t(:your_statistic))
      end
    end

    context 'if ranking for other user' do

      it 'returns text with other users name' do
        presenter = subject.new(current_user, user.id, games)
        expect(presenter.header_text).to eq(I18n.t(:statistic_for, name: user.name))
      end
    end
  end

  describe '#line_chart_header_text' do

    it 'returns correct text' do
      presenter = subject.new(current_user, current_user.id, games)
      expect(presenter.line_chart_header_text).to eq(I18n.t(:ranking_per_game))
    end
  end

  describe '#line_chart_x_labels' do

    it 'calls GamePresenter' do
      presenter = subject.new(current_user, current_user.id, games)
      expect(games).to receive(:map).and_return([
                                                  GamePresenter.new(games[0]),
                                                  GamePresenter.new(games[1]),
                                                  GamePresenter.new(games[2])])

      # no teams definied on the games
      expected = [
        "#{ I18n.l(games[0].start_at, format: :short)}:  - ",
        "#{ I18n.l(games[1].start_at, format: :short)}:  - ",
        "#{ I18n.l(games[2].start_at, format: :short)}:  - ",
      ]
      expect(presenter.line_chart_x_labels).to eq(expected)
    end
  end

  describe '#line_chart_max_ticks' do

    context 'if user data present' do

      it 'returns max user data' do
        presenter = subject.new(current_user, user.id, games)
        expect(presenter).to receive(:user_rankings).and_return(user_rankings + [6])

        expect(presenter.line_chart_max_ticks).to eq(6)
      end

      it 'returns 5 if max user data < 5' do
        presenter = subject.new(current_user, user.id, games)
        expect(presenter).to receive(:user_rankings).and_return(user_rankings)

        expect(presenter.line_chart_max_ticks).to eq(5)
      end
    end

    context 'if user data not present' do

      it 'returns 5' do
        presenter = subject.new(current_user, user.id, games)
        expect(presenter).to receive(:user_rankings).and_return([nil, nil, nil])

        expect(presenter.line_chart_max_ticks).to eq(5)
      end
    end
  end

  describe '#line_chart_step_size' do

    context 'if user data present' do

      it 'returns max user data with diff 20' do
        presenter = subject.new(current_user, user.id, games)
        expect(presenter).to receive(:user_rankings).and_return([nil, 1, 20])

        expect(presenter.line_chart_step_size).to eq(1)
      end

      it 'returns max user data with diff 21' do
        presenter = subject.new(current_user, user.id, games)
        expect(presenter).to receive(:user_rankings).and_return([nil, 1, 21])

        expect(presenter.line_chart_step_size).to eq(5)
      end

      it 'returns max user data with diff 80' do
        presenter = subject.new(current_user, user.id, games)
        expect(presenter).to receive(:user_rankings).and_return([nil, 1, 51])

        expect(presenter.line_chart_step_size).to eq(5)
      end

      it 'returns max user data with diff 80' do
        presenter = subject.new(current_user, user.id, games)
        expect(presenter).to receive(:user_rankings).and_return([nil, 1, 52])

        expect(presenter.line_chart_step_size).to eq(10)
      end
    end

    context 'if user data not present' do

      it 'returns 1' do
        presenter = subject.new(current_user, user.id, games)
        expect(presenter).to receive(:user_rankings).and_return([nil, nil, nil])

        expect(presenter.line_chart_step_size).to eq(5)
      end
    end
  end

  describe '#line_chart_data' do

    it 'returns line_chart_data' do
      presenter = subject.new(current_user, user.id, games)
      expect(presenter).to receive(:line_chart_x_labels).and_return(line_chart_x_labels)
      expect(presenter).to receive(:user_rankings).and_return(user_rankings)

      expect(presenter.line_chart_data).to eq(
                                        {
                                          labels: ['Label1', 'Label2', 'Label3'],
                                          datasets: [
                                            {
                                              label: I18n.t(:standings),
                                              fill: false,
                                              lineTension: 0.2,
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

  describe '#line_chart_options' do

    it 'returns line_chart_options' do
      presenter = subject.new(current_user, user.id, games)
      expect(presenter).to receive(:line_chart_max_ticks).and_return(23)
      expect(presenter).to receive(:line_chart_step_size).and_return(5)

      expect(presenter.line_chart_options).to eq(
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
                                                     reverse: true,
                                                     min: 1,
                                                     max: 23,
                                                     stepSize: 5
                                                   }
                                                 }
                                               ]
                                             },
                                           }
                                         )
    end
  end

  describe '#has_data_to_show?' do

    context 'if user present and user_rankings present?' do
      it 'returns true' do
        presenter = subject.new(current_user, user.id, games)
        expect(presenter).to receive(:user_rankings).twice.and_return(user_rankings)
        expect(presenter.has_data_to_show?).to be true
      end
    end

    context 'if user present and user_rankings not present?' do
      it 'returns false' do
        presenter = subject.new(current_user, user.id, games)
        expect(presenter).to receive(:user_rankings).and_return([])
        expect(presenter.has_data_to_show?).to be false
      end
    end
  end
end