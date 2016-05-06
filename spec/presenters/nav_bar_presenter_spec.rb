require 'rails_helper'

describe NavBarPresenter do

  let(:user) { build(:active_admin) }

  subject { NavBarPresenter }

  describe '#active_css_class?' do

    let(:presenter) { subject.new(:admin, user) }

    context 'if url_scope == effective_url_scope' do

      it "returns 'active'" do
        expect(presenter.active_css_class(:admin)).to eq('active')
      end
    end

    context 'if url_scope != effective_url_scope' do

      it "returns ''" do
        expect(presenter.active_css_class(:help)).to eq('')
      end
    end
  end

  describe '#nav_bar_brand_url' do

    it 'returns root_url' do
      expect(subject.new(:admin, user).nav_bar_brand_url).to eq(root_path)
    end
  end

  describe '#nav_bar_item_presenters?' do

    context 'if user not present' do

      it 'returns NavBarItemPresenter for help' do
        presenter = subject.new(:admin, nil)
        nav_bar_item_presenters = presenter.nav_bar_item_presenters

        expect(nav_bar_item_presenters.size).to eq(1)
        second = nav_bar_item_presenters.last
        expect(second).to be_a(NavBarItemPresenter)
        expect(second.link_url).to eq(help_path)
      end
    end

    context 'if user present' do

      let(:presenter) { subject.new(:tips, user) }

      it 'returns all NavBarItemPresenters' do
        nav_bar_item_presenters = presenter.nav_bar_item_presenters

        expect(nav_bar_item_presenters.size).to eq(5)
        expect(nav_bar_item_presenters[0]).to be_a(NavBarItemPresenter)
        expect(nav_bar_item_presenters[0].link_url).to eq(tips_path)
        expect(nav_bar_item_presenters[1]).to be_a(NavBarItemPresenter)
        expect(nav_bar_item_presenters[1].link_url).to eq(ranking_path)
        expect(nav_bar_item_presenters[2]).to be_a(NavBarItemPresenter)
        expect(nav_bar_item_presenters[2].link_url).to eq(notes_path)
        expect(nav_bar_item_presenters[3]).to be_a(NavBarItemPresenter)
        expect(nav_bar_item_presenters[3].link_url).to eq(compare_tips_path)
        expect(nav_bar_item_presenters[4]).to be_a(NavBarItemPresenter)
        expect(nav_bar_item_presenters[4].link_url).to eq(help_path)
      end
    end
  end

  describe '#nav_bar_item_user_presenter?' do

    it 'returns a proper NavBarItemPresenter' do
      presenter = subject.new(:user, user)
      nav_bar_item_presenter = presenter.nav_bar_item_user_presenter

      expect(nav_bar_item_presenter).to be_a(NavBarItemPresenter)
      expect(nav_bar_item_presenter.sub_menu_id).to eq(:current_user_sub_menu)
    end
  end

  describe '#user_logged_in?' do

    context 'if user present' do

      it 'returns true' do
        presenter = subject.new(:admin, user)
        expect(presenter.user_logged_in?).to be true
      end
    end

    context 'if user not present' do

      it 'returns false' do
        presenter = subject.new(:admin, nil)
        expect(presenter.user_logged_in?).to be false
      end
    end
  end

end