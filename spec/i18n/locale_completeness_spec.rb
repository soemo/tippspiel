# frozen_string_literal: true

require 'rails_helper'

# Ensures both locale files are complete and consistent.
# Driven directly from the YAML files — no manual key lists to maintain.
# Adding a key to one locale file will automatically fail this spec
# until the other locale is updated too.

# Rails provides these namespaces via its own locale gems — we don't need
# to duplicate them in our en.yml.
LOCALE_RAILS_OWNED_NAMESPACES = %w[datetime date time number activerecord activemodel errors].freeze

LOCALE_KNOWN_GERMAN_WORDS = %w[bitte deine danke spielen runde achtelfinale viertelfinale
                               halbfinale finale punkte mannschaft turnier bonusfragen].freeze

# Brand name — intentionally identical in both locales.
LOCALE_SKIP_GERMAN_CHECK_KEYS = %w[app_name].freeze

describe 'I18n locale completeness' do
  def load_locale(locale)
    path = Rails.root.join("config/locales/#{locale}.yml")
    YAML.load_file(path)[locale.to_s]
  end

  def flatten_keys(hash, prefix = '')
    hash.each_with_object([]) do |(k, v), keys|
      full_key = prefix.empty? ? k.to_s : "#{prefix}.#{k}"
      if v.is_a?(Hash)
        keys.concat(flatten_keys(v, full_key))
      else
        keys << full_key
      end
    end
  end

  def app_keys(hash)
    flatten_keys(hash).reject do |key|
      LOCALE_RAILS_OWNED_NAMESPACES.any? { |ns| key.start_with?(ns) }
    end
  end

  let(:de_keys) { app_keys(load_locale(:de)).sort }
  let(:en_keys) { app_keys(load_locale(:en)).sort }

  describe 'symmetry' do
    it 'every de key exists in en' do
      missing = de_keys - en_keys
      expect(missing).to be_empty,
                         "Keys in de.yml but missing from en.yml:\n#{missing.join("\n")}"
    end

    it 'every en key exists in de' do
      missing = en_keys - de_keys
      expect(missing).to be_empty,
                         "Keys in en.yml but missing from de.yml:\n#{missing.join("\n")}"
    end
  end

  describe 'no empty values' do
    it 'de.yml has no blank values' do
      blank = de_keys.select { |k| I18n.t(k, locale: :de, default: '').to_s.strip.empty? }
      expect(blank).to be_empty, "Blank values in de.yml:\n#{blank.join("\n")}"
    end

    it 'en.yml has no blank values' do
      blank = en_keys.select { |k| I18n.t(k, locale: :en, default: '').to_s.strip.empty? }
      expect(blank).to be_empty, "Blank values in en.yml:\n#{blank.join("\n")}"
    end
  end

  describe 'no German leaking into en.yml' do
    it 'contains no untranslated German strings in en.yml' do
      offenders = []
      (en_keys - LOCALE_SKIP_GERMAN_CHECK_KEYS).each do |key|
        value = I18n.t(key, locale: :en, default: '').to_s.downcase
        LOCALE_KNOWN_GERMAN_WORDS.each do |word|
          offenders << "#{key}: '#{word}' found in '#{value}'" if value.include?(word)
        end
      end
      expect(offenders).to be_empty, "German words in en.yml:\n#{offenders.join("\n")}"
    end
  end

  describe 'round keys' do
    required_rounds = %w[group roundof32 roundof16 quarterfinal semifinal place3 final]

    required_rounds.each do |round|
      it "round.#{round} is translated differently in de and en" do
        de_val = I18n.t("round.#{round}", locale: :de)
        en_val = I18n.t("round.#{round}", locale: :en)
        expect(de_val).not_to match(/translation missing/)
        expect(en_val).not_to match(/translation missing/)
        expect(de_val).not_to eq(en_val),
                              "round.#{round} is identical in de and en — likely not translated"
      end
    end
  end
end
