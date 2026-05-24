# frozen_string_literal: true

require 'rails_helper'

describe LocalesController do
  let(:current_user) { create(:active_user) }

  # HTTP_REFERER must be a full URL; Rails controller specs use 'http://test.host' as default host.
  def referer(path)
    "http://test.host#{path}"
  end

  describe 'PATCH #update' do
    context 'with a supported locale (en)' do
      it 'stores locale in session' do
        login current_user
        patch :update, params: { locale: 'en' }
        expect(session[:locale]).to eq('en')
      end
    end

    context 'with a supported locale (de)' do
      it 'stores locale in session' do
        login current_user
        patch :update, params: { locale: 'de' }
        expect(session[:locale]).to eq('de')
      end
    end

    context 'with an unsupported locale' do
      it 'stores de as fallback in session' do
        login current_user
        patch :update, params: { locale: 'fr' }
        expect(session[:locale]).to eq('de')
      end
    end

    context 'redirect behaviour when signed in' do
      before { login current_user }

      it 'redirects back to a protected page (e.g. /rankings)' do
        request.env['HTTP_REFERER'] = referer(rankings_path)
        patch :update, params: { locale: 'en' }
        expect(response).to redirect_to(referer(rankings_path))
      end

      it 'redirects back to a protected page (e.g. /comparetips)' do
        request.env['HTTP_REFERER'] = referer(compare_tips_path)
        patch :update, params: { locale: 'en' }
        expect(response).to redirect_to(referer(compare_tips_path))
      end

      it 'redirects back to root' do
        request.env['HTTP_REFERER'] = referer(root_path)
        patch :update, params: { locale: 'en' }
        expect(response).to redirect_to(referer(root_path))
      end

      it 'redirects to root when referer is blank' do
        request.env['HTTP_REFERER'] = nil
        patch :update, params: { locale: 'en' }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'redirect behaviour when not signed in' do
      it 'redirects back to the sign-in page' do
        request.env['HTTP_REFERER'] = referer(new_user_session_path)
        patch :update, params: { locale: 'en' }
        expect(response).to redirect_to(referer(new_user_session_path))
      end

      it 'redirects back to the imprint page' do
        request.env['HTTP_REFERER'] = referer(imprint_path)
        patch :update, params: { locale: 'en' }
        expect(response).to redirect_to(referer(imprint_path))
      end

      it 'redirects back to the help page' do
        request.env['HTTP_REFERER'] = referer(help_path)
        patch :update, params: { locale: 'en' }
        expect(response).to redirect_to(referer(help_path))
      end

      it 'redirects to sign-in when referer is blank' do
        request.env['HTTP_REFERER'] = nil
        patch :update, params: { locale: 'en' }
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'redirects to sign-in when referer is a protected page' do
        request.env['HTTP_REFERER'] = referer(rankings_path)
        patch :update, params: { locale: 'en' }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
