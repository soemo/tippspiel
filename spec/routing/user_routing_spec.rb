require 'rails_helper'

describe UserController, :type => :routing do
  describe 'routing' do
    it 'for User' do
        assert_routing({ :path => '/user/edit_password', :method => :get }, { :controller => 'user', :action => 'edit_password' })
        assert_routing({ :path => '/user/change_password', :method => :post }, { :controller => 'user', :action => 'change_password' })
      end
  end
end
