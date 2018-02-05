require 'rails_helper'

describe MainController, :type => :controller do

  let!(:user) {create :active_user}
  let(:tips) {[Tip.new, Tip.new]}

  describe '#index with login' do

    it 'be successful with login' do
      expect(Tips::FromUser).to receive(:call).with(user_id: user.id).
          and_return(tips)

      login(user)
      get :index
      expect(assigns(:presenter)).to be_instance_of MainIndexPresenter
      expect(assigns(:presenter).current_user).to eq user
      expect(assigns(:presenter).tips).to eq tips
      expect(response).to have_http_status(:success)
      expect(response).to render_template :index
      expect(response).to be_success
    end
  end

  describe '#index without login' do

    it 'be redirected to root' do
      get 'index'
      expect(response).to redirect_to new_user_session_path
    end
  end
end
