require 'rails_helper'

describe HelpsController, :type => :controller do

  describe '#show' do
    render_views
    
    it 'renders successful' do
      get :show
      expect(response).to be_successful
    end
  end

end
