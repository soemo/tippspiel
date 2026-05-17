# frozen_string_literal: true

require 'rails_helper'

describe TeamPresenter do
  subject { described_class.new(team) }

  let(:team) { build(:team, name: 'Deutschland', country_code: 'de') }

  it { is_expected.to respond_to(:team) }

  it 'delegates all method calls to team by default' do
    expect(subject.name).to eq 'Deutschland'
  end

  describe '#translated_name' do
    it 'returns the German name when locale is :de' do
      I18n.with_locale(:de) do
        expect(subject.translated_name).to eq 'Deutschland'
      end
    end

    it 'returns the English name when locale is :en' do
      I18n.with_locale(:en) do
        expect(subject.translated_name).to eq 'Germany'
      end
    end

    it 'falls back to team.name when country_code has no translation' do
      team = build(:team, name: 'Unknown FC', country_code: 'xx')
      presenter = described_class.new(team)
      I18n.with_locale(:en) do
        expect(presenter.translated_name).to eq 'Unknown FC'
      end
    end
  end

  describe '#team_name_with_flag' do
    it 'returns translated name with right flag' do
      flag_size = 16
      flag_position = 'right'
      allow(subject).to receive(:teamflag).with(flag_size).and_return('flag string')

      I18n.with_locale(:en) do
        expected = 'Germany flag string'
        expect(subject.team_name_with_flag(flag_size: flag_size,
                                           flag_position: flag_position)).to eq expected
      end
    end

    it 'returns translated name with left flag' do
      flag_size = 16
      flag_position = 'left'
      allow(subject).to receive(:teamflag).with(flag_size).and_return('flag string')

      I18n.with_locale(:en) do
        expected = 'flag string Germany'
        expect(subject.team_name_with_flag(flag_size: flag_size,
                                           flag_position: flag_position)).to eq expected
      end
    end

    it 'raises error if flag_position is not left or right' do
      flag_size = 16
      flag_position = 'top'
      allow(subject).to receive(:teamflag).with(flag_size).and_return('flag string')

      expect do
        subject.team_name_with_flag(flag_size: flag_size,
                                    flag_position: flag_position)
      end.to raise_error("Wrong flag_position #{flag_position}")
    end
  end

  describe '#teamflag' do
    it 'returns teamflag html' do
      expect(subject.teamflag(16)).to eq("<span class='f16'><i class='flag #{team.country_code}'></i></span>")
    end
  end
end
