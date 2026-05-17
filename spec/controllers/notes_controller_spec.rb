# frozen_string_literal: true

require 'rails_helper'

describe NotesController do
  let(:max_long_word) { 'a' * Notice::MAX_SIZE_WITHOUT_SPACES }

  describe '#index with login' do
    it 'be successful' do
      login(create(:active_user))
      get :index
      expect(response).to be_successful
    end
  end

  describe '#index without login' do
    it 'be redirected to root' do
      get :index
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe '#create with login' do
    before do
      login(create(:active_user))
    end

    it 'be successful' do
      post :create
      expect(response).to redirect_to notes_path
    end

    it 'add notice' do
      expect(Notice.count).to eq(0)
      post :create, params: { text: max_long_word }
      expect(response).to redirect_to notes_path
      expect(flash[:notice]).to eq(I18n.t(:create_successful, object_name: Notice.model_name.human))
      expect(Notice.count).to eq(1)
    end

    it 'does not save notice, if no text present' do
      expect(Notice.count).to eq(0)
      post :create, params: { text: '' }
      expect(response).to redirect_to notes_path
      expect(flash[:error]).to eq(I18n.t(:notice_needs_a_comment))
      expect(Notice.count).to eq(0)
    end

    it 'does not save notice, if to long word without spaces' do
      too_long_word_without_spaces = "#{max_long_word}b"
      expect(Notice.count).to eq(0)
      post :create, params: { text: too_long_word_without_spaces }
      expect(response).to redirect_to notes_path
      expect(flash[:error]).to eq(I18n.t(:notice_needs_spaces))
      expect(Notice.count).to eq(0)
    end
  end

  describe '#create without login' do
    it 'be redirected to root' do
      post :create
      expect(response).to redirect_to new_user_session_path
    end
  end
end
