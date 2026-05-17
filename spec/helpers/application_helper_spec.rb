# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper do
  before do
    helper.extend Haml
    helper.extend Haml::Helpers
    helper.send :init_haml_helpers
  end

  describe '#get_title' do
    it 'return Tournament Name + Tippspiel' do
      expect(helper.get_title).to eq("#{I18n.t('tournament_name')} #{t('app_name')}")
    end
  end

  describe '#tip_filter_sections' do
    it 'returns status, group and round sections with translated labels' do
      sections = helper.tip_filter_sections

      expect(sections.map { |s| s[:title] }).to eq(%w[Status Gruppe Runde])

      status = sections[0]
      expect(status[:options]).to eq([
                                       { label: 'Alle Spiele', data_filter: 'all', default: true },
                                       { label: 'Heutige Spiele', data_filter: '.category-today', default: false },
                                       { label: 'Offene Spiele',  data_filter: '.category-future', default: false }
                                     ])

      group = sections[1]
      expect(group[:options].first).to eq(
        label: 'Gruppe A', data_filter: '.category-group-A', default: false
      )
      expect(group[:options].size).to eq(GROUPS.size)

      round = sections[2]
      # The group round is excluded — group filter is its own section.
      expect(round[:options].map { |o| o[:label] }).not_to include('Gruppe')
      expect(round[:options]).to include(
        a_hash_including(data_filter: '.category-round-final', default: false)
      )
    end
  end

  describe '#write_flash' do
    context 'if msg present?' do
      it 'returns div.alert box with msg and css_class' do
        expected = <<~HTML
          <div class='alert-box error_css_class' data-closable=''>
            test123
            <button class='close-button' data-close=''>
              &times;
            </button>
          </div>
        HTML

        expect(helper.capture_haml do
          helper.write_flash('test123', 'error_css_class')
        end).to eq(expected)
      end
    end

    context 'if msg not present?' do
      it 'returns nothing' do
        expect(helper.capture_haml do
          helper.write_flash('', 'error_css_class')
        end).to be_nil
      end
    end

    context 'if msg is a Array with one element' do
      it 'returns div.alert box with msg and css_class' do
        expected = <<~HTML
          <div class='alert-box error_css_class' data-closable=''>
            test123
            <button class='close-button' data-close=''>
              &times;
            </button>
          </div>
        HTML

        expect(helper.capture_haml do
          helper.write_flash(['test123'], 'error_css_class')
        end).to eq(expected)
      end
    end

    context 'if msg is a Array with more than one element' do
      it 'raise an error' do
        expect do
          helper.write_flash(%w[test123 test456], 'error_css_class')
        end.to raise_error(RuntimeError)
      end
    end
  end
end
