# frozen_string_literal: true

require 'rails_helper'

describe HealthChecksController do
  describe 'GET #show' do
    context 'when the database is available' do
      it 'returns 200 OK' do
        get :show
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the database is unavailable' do
      before do
        allow(ActiveRecord::Base.connection).to receive(:execute).and_raise(ActiveRecord::StatementInvalid)
      end

      it 'returns 503 Service Unavailable' do
        get :show
        expect(response).to have_http_status(:service_unavailable)
      end
    end

    context 'without authentication' do
      it 'does not redirect to login' do
        get :show
        expect(response).not_to redirect_to(new_user_session_path)
      end
    end
  end
end
