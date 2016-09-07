require 'rails_helper'

describe HelpsController, :type => :controller do

  describe '#show' do
    it 'renders successful' do
      get :show
      expect(response).to be_success
    end
  end

end
