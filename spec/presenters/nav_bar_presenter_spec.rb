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

  describe '#nav_bar_title' do

    context 'if user is logged in' do
      it 'returns "#{TOURNAMENT_NAME} #{I18n.t(your_tips)}"' do
        expect(subject.new(:admin, user).nav_bar_title).to eq("#{TOURNAMENT_NAME} #{t('your_tips')}")
      end
    end

    context 'if user is not logged in' do
      it 'returns "#{TOURNAMENT_NAME} #{I18n.t(app_name)}"' do
        expect(subject.new(:admin, nil).nav_bar_title).to eq("#{TOURNAMENT_NAME} #{t('app_name')}")
      end
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

      let(:presenter) { subject.new(:main, user) }

      it 'returns all NavBarItemPresenters' do
        nav_bar_item_presenters = presenter.nav_bar_item_presenters

        expect(nav_bar_item_presenters.size).to eq(6)

        expect(nav_bar_item_presenters[0]).to be_a(NavBarItemPresenter)
        expect(nav_bar_item_presenters[0].link_url).to eq(edit_bonus_path)
        expect(nav_bar_item_presenters[0].link_text).to eq(I18n.t('bonus'))
        expect(nav_bar_item_presenters[0].link_icon_prefix).to eq('fas')
        expect(nav_bar_item_presenters[0].link_icon).to eq('rocket')

        expect(nav_bar_item_presenters[1]).to be_a(NavBarItemPresenter)
        expect(nav_bar_item_presenters[1].link_url).to eq(rankings_path)
        expect(nav_bar_item_presenters[1].link_text).to eq(I18n.t('ranking'))
        expect(nav_bar_item_presenters[1].link_icon_prefix).to eq('fas')
        expect(nav_bar_item_presenters[1].link_icon).to eq('list-ol')

        expect(nav_bar_item_presenters[2]).to be_a(NavBarItemPresenter)
        expect(nav_bar_item_presenters[2].link_url).to eq(notes_path)
        expect(nav_bar_item_presenters[2].link_text).to eq(I18n.t('notice'))
        expect(nav_bar_item_presenters[2].link_icon_prefix).to eq('far')
        expect(nav_bar_item_presenters[2].link_icon).to eq('comments')

        expect(nav_bar_item_presenters[3]).to be_a(NavBarItemPresenter)
        expect(nav_bar_item_presenters[3].link_url).to eq(compare_tips_path)
        expect(nav_bar_item_presenters[3].link_text).to eq(I18n.t('comparetips'))
        expect(nav_bar_item_presenters[3].link_icon_prefix).to eq('fas')
        expect(nav_bar_item_presenters[3].link_icon).to eq('angle-double-right')

        expect(nav_bar_item_presenters[4]).to be_a(NavBarItemPresenter)
        expect(nav_bar_item_presenters[4].link_url).to eq(help_path)
        expect(nav_bar_item_presenters[4].link_text).to be_nil
        expect(nav_bar_item_presenters[4].link_icon_prefix).to eq('far')
        expect(nav_bar_item_presenters[4].link_icon).to eq('question-circle')

        expect(nav_bar_item_presenters[5]).to be_a(NavBarItemPresenter)
        expect(nav_bar_item_presenters[5].link_url).to eq(logout_path)
        expect(nav_bar_item_presenters[5].link_text).to eq(I18n.t('sign_out'))
        expect(nav_bar_item_presenters[5].link_icon_prefix).to eq('fas')
        expect(nav_bar_item_presenters[5].link_icon).to eq('sign-out-alt')
      end
    end
  end

  describe '#user_position' do
    let(:presenter) { subject.new(:main, user) }

    it 'returns nav_ranking_info' do
      object = double('Top3AndOwnPosition', user_top3_ranking_hash: {}, own_position: 42)
      expect(Users::Top3AndOwnPosition).to receive(:call).with(user_id: user.id).and_return(object)

      expect(presenter.user_position).to eq(42)
    end
  end

  describe '#nav_ranking_info' do

    let(:presenter) { subject.new(:main, user) }

    it 'returns nav_ranking_info if Tournament has started' do
      expect(Tournament).to receive(:started?).and_return(true)
      object = double('Top3AndOwnPosition', user_top3_ranking_hash: {}, own_position: 42)
      user.points = 111
      expect(Users::Top3AndOwnPosition).to receive(:call).with(user_id: user.id).and_return(object)

      expect(presenter.nav_ranking_info).to eq('Platz 42 mit 111 Punkten')
    end

    it 'returns empty nav_ranking_info if Tournament has not started' do
      expect(Tournament).to receive(:started?).and_return(false)
      expect(Users::Top3AndOwnPosition).not_to receive(:call).with(user_id: user.id)

      expect(presenter.nav_ranking_info).to eq('')
    end
  end
end