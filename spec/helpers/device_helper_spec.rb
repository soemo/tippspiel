require 'rails_helper'

describe DeviceHelper, type: :helper do

  before :each do
    helper.extend Haml
    helper.extend Haml::Helpers
    helper.send :init_haml_helpers
  end

  describe '#resource_name' do

    it 'return :user' do
      expect(helper.resource_name).to eq(:user)
    end
  end

  describe '#resource' do

    it 'return new User' do
      user = User.new
      expect(User).to receive(:new).and_return(user)
      expect(helper.resource).to eq(user)
      # use cache
      expect(helper.resource).to eq(user)
    end
  end

  describe '#custom_devise_error_messages!' do

    context 'if errors present on resource' do

      it 'returns div.alert box with resource full_messages' do
        user = User.new
        user.errors.add(:base, 'test123')
        user.errors.add(:base, 'test456')
        expect(helper).to receive(:resource).twice.and_return(user)
        expected = <<-HTML
      <div data-closable class='alert-box alert'>
        test123<br/>test456
        <button class="close-button" data-close>&times;</button>
      </div>
        HTML
        
        expect(helper.capture_haml{
          helper.custom_devise_error_messages!
        }).to eq(expected)
      end
    end

    context 'if resource has no errors' do

      it 'returns empty string' do
        expect(helper.capture_haml{
          helper.custom_devise_error_messages!
        }).to eq('')
      end
    end
  end

  describe '#devise_mapping' do

    it 'returns devisce mapping for user' do
      dmu = Devise.mappings[:user]
      expect(helper.devise_mapping).to eq(dmu)
      # caching
      expect(helper.devise_mapping).to eq(dmu)
    end
  end
end
