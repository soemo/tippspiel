require 'rails_helper'

describe ImprintsController, type: :controller do

  describe '#show' do
    render_views
    
    it 'renders successful' do
      get :show
      expect(response).to be_success
    end
  end

end
