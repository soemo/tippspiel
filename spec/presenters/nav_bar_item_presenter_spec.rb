require 'rails_helper'

describe NavBarItemPresenter do

  subject { NavBarItemPresenter }

  describe '#init' do
    it 'returns true' do
      presenter = subject.new('lock', 'text', '/',  'css_class')
      expect(presenter.link_icon).to eq('lock')
      expect(presenter.link_text).to eq('text')
      expect(presenter.link_url).to eq('/')
      expect(presenter.css_class).to eq('css_class')
    end
  end
end