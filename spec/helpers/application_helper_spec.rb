require 'rails_helper'

describe ApplicationHelper, type: :helper do

  before :each do
    helper.extend Haml
    helper.extend Haml::Helpers
    helper.send :init_haml_helpers
  end

  describe '#get_title' do

    it 'return Name + Tippspiel' do
      expect(helper.get_title).to eq("#{TOURNAMENT_NAME} #{t('app_name')}")
    end
  end

  describe '#filter_categories_options' do

    it 'returns mixitup filter buuton options' do
      expect(helper.filter_categories_options).to eq(
                                                      [{:label=>"Alle Spiele",
                                                        :class=>"filter button active",
                                                        :data_filter=>"all"},
                                                       {:label=>"Heutige Spiele",
                                                        :class=>"filter button",
                                                        :data_filter=>".category-today"},
                                                       {:label=>"Offene Spiele",
                                                        :class=>"filter button",
                                                        :data_filter=>".category-future"}]
                                                  )
    end
  end

  describe '#write_flash' do

    context 'if msg present?' do

      it 'returns div.alert box with msg and css_class' do
        expected = <<-HTML
<div class='alert-box error_css_class' data-closable=''>
  test123
  <button class='close-button' data-close=''>
    &times;
  </button>
</div>
        HTML
        
        expect(helper.capture_haml{
          helper.write_flash('test123', 'error_css_class')
        }).to eq(expected)
      end
    end

    context 'if msg not present?' do

      it 'returns nothing' do
        expect(helper.capture_haml{
          helper.write_flash('', 'error_css_class')
        }).to be nil
      end
    end

    context 'if msg is a Array with one element' do

      it 'returns div.alert box with msg and css_class' do
        expected = <<-HTML
<div class='alert-box error_css_class' data-closable=''>
  test123
  <button class='close-button' data-close=''>
    &times;
  </button>
</div>
        HTML

        expect(helper.capture_haml{
          helper.write_flash(['test123'], 'error_css_class')
        }).to eq(expected)
      end
    end

    context 'if msg is a Array with more than one element' do

      it 'raise an error' do
        expect{
          helper.write_flash(['test123', 'test456'], 'error_css_class')
        }.to raise_error(RuntimeError)
      end
    end
  end
end
