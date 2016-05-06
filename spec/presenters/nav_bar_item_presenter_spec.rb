require 'rails_helper'

describe NavBarItemPresenter do

  subject { NavBarItemPresenter }

  describe '#has_sub_menu?' do

    context 'if sub_menu_id present' do

      it 'returns true' do
        presenter = subject.new('text', '/', :sub_menu_id, [], '')
        expect(presenter.has_sub_menu?).to be true
      end
    end

    context 'if sub_menu_id not present' do

      it 'returns false' do
        presenter = subject.new('text', '/', nil, nil, '')
        expect(presenter.has_sub_menu?).to be false
      end
    end
  end



end