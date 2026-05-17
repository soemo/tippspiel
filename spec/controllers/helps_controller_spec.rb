# frozen_string_literal: true

require 'rails_helper'

describe HelpsController do
  describe '#show' do
    render_views

    it 'renders successful' do
      get :show
      expect(response).to be_successful
    end
  end
end
