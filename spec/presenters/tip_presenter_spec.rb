require 'rails_helper'

describe TipPresenter do

  subject { TipPresenter.new(tip) }

  let(:tip) { build(:tip) }

  it { is_expected.to respond_to(:tip) }

  it 'delegates all method calls to tip by default' do
    tip.team1_goals = 2
    expect(subject.team1_goals).to eq 2
  end

  describe '#pointbadge_large' do

    it 'returns pointbadge_large html' do
      expected =  "<span class='large-point-badge extra_css_class eight-point-background-color badge' title='8 Punkte'>8</span>"
      expect(subject.pointbadge_large(8, 'extra_css_class')).to eq(expected)
    end
  end

  describe '#pointbadge' do

    it 'returns pointbadge html' do
      expected =  "<span class='extra_css_class eight-point-background-color badge' title='8 Punkte'>8</span>"
      expect(subject.pointbadge(8, 'extra_css_class')).to eq(expected)
    end
  end
end