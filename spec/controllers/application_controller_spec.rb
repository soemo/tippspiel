require 'rails_helper'

describe ApplicationController do

  subject { controller }
  let(:current_user) { create(:active_admin)}

  it { is_expected.to filter_param(:password) }

  before :each do
    login current_user
  end

  describe '#nav_bar_presenter' do

    it 'returns instance of NavBarPresenter' do
      current_url_scope = '/templates'
      expect(subject).to receive(:url_scope).and_return(current_url_scope)

      nav_bar_presenter = subject.nav_bar_presenter

      expect(nav_bar_presenter).to be_instance_of NavBarPresenter
      expect(nav_bar_presenter.user).to eq current_user
      expect(nav_bar_presenter.url_scope).to be current_url_scope
    end
  end

  describe '#url_scope' do

    before :each do
      expect(subject).to receive(:request).and_return(request)
    end

    context 'if request path starts with /admin' do

      let(:request) { double('request', path: '/admin/some-path') }

      it 'returns admin' do
        expect(subject.url_scope).to eq(URL_SCOPES[:admin])
        expect(subject.url_scope.admin?).to be true
      end
    end

    context 'if request path starts with /comparetips' do

      let(:request) { double('request', path: '/comparetips') }

      it 'returns comparetips' do
        expect(subject.url_scope).to eq(URL_SCOPES[:comparetips])
        expect(subject.url_scope.comparetips?).to be true
      end
    end

    context 'if request path starts with /help' do

      let(:request) { double('request', path: '/help') }

      it 'returns help' do
        expect(subject.url_scope).to eq(URL_SCOPES[:help])
        expect(subject.url_scope.help?).to be true
      end
    end

    context 'if request path starts with /notes' do

      let(:request) { double('request', path: '/notes') }

      it 'returns notes' do
        expect(subject.url_scope).to eq(URL_SCOPES[:notes])
        expect(subject.url_scope.notes?).to be true
      end
    end

    context 'if request path starts with /ranking' do

      let(:request) { double('request', path: '/ranking') }

      it 'returns ranking' do
        expect(subject.url_scope).to eq(URL_SCOPES[:ranking])
        expect(subject.url_scope.ranking?).to be true
      end
    end

    context 'if request path starts with /user' do

      let(:request) { double('request', path: '/user/some-path') }

      it 'returns user' do
        expect(subject.url_scope).to eq(URL_SCOPES[:user])
        expect(subject.url_scope.user?).to be true
      end
    end

    context 'if path starts with something unknown' do

      let(:request) { double('request', path: '/blablub/admin/some-path') }

      it 'returns blank' do
        expect(subject.url_scope).to eq('')
      end
    end
  end
end
