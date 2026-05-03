require 'rails_helper'

describe LocalesController do

  let(:current_user) { create(:active_user) }

  before { login current_user }

  describe 'PATCH #update' do

    context 'with a supported locale (en)' do
      it 'stores locale in session' do
        patch :update, params: { locale: 'en' }
        expect(session[:locale]).to eq('en')
      end

      it 'redirects back' do
        request.env['HTTP_REFERER'] = root_path
        patch :update, params: { locale: 'en' }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with a supported locale (de)' do
      it 'stores locale in session' do
        patch :update, params: { locale: 'de' }
        expect(session[:locale]).to eq('de')
      end
    end

    context 'with an unsupported locale' do
      it 'stores de as fallback in session' do
        patch :update, params: { locale: 'fr' }
        expect(session[:locale]).to eq('de')
      end
    end
  end
end
