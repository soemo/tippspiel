require 'rails_helper'

describe TeamPresenter do

  subject { TeamPresenter.new(team) }

  let(:team) { build(:team, country_code: 'de') }

  it { is_expected.to respond_to(:team) }

  it 'delegates all method calls to team by default' do
    team.name = 'Deutschland'
    expect(subject.name).to eq 'Deutschland'
  end

  describe '#team_with_flags' do

    it 'returns team name with right flag' do
      flag_size = 16
      flag_position = 'right'
      expect(subject).to receive(:teamflag).with(flag_size).and_return('flag string')

      expected = "#{team.name} flag string"
      expect(subject.team_name_with_flag(flag_size: flag_size,
                                         flag_position: flag_position)).to eq expected
    end

    it 'returns team name with left flag' do
      flag_size = 16
      flag_position = 'left'
      expect(subject).to receive(:teamflag).with(flag_size).and_return('flag string')

      expected = "flag string #{team.name}"
      expect(subject.team_name_with_flag(flag_size: flag_size,
                                         flag_position: flag_position)).to eq expected
    end

    it 'raise error if flag_position is not left or right' do
      flag_size = 16
      flag_position = 'top'
      expect(subject).to receive(:teamflag).with(flag_size).and_return('flag string')

      expected = "flag string #{team.name}"
      expect{
        subject.team_name_with_flag(flag_size: flag_size,
                                         flag_position: flag_position)
      }.to raise_error("Wrong flag_position #{flag_position}")
    end
  end

  describe '#teamflag' do

    it 'returns teamflag html' do
      expect(subject.teamflag(16)).to eq("<span class='f16'><i class='flag #{team.country_code}'></i></span>")
    end
  end
end