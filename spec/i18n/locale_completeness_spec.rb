require 'rails_helper'

# Ensures both locale files are complete and consistent.
# Tests run against the loaded I18n backend — fast, no DB needed.

describe 'I18n locale completeness' do
  # All round keys the app needs — including the new WM 2026 round
  REQUIRED_ROUND_KEYS = %w[group roundof32 roundof16 quarterfinal semifinal place3 final].freeze

  # Keys that must exist and be translated in both locales
  REQUIRED_APP_KEYS = %w[
    app_name
    games_of
    text_maintenance
    error_stale_object
    error_record_not_found
    error_auth_token
    delete_secure_question
    succesfully_saved_tips
    succesfully_saved_bonustip
    create_successful
    update_successful
    notice_needs_a_comment
    notice_needs_spaces
    bonus_question_help
    no_champion_tip
    no_second_tip
    no_when_first_goal_tip
    no_how_many_goals_tip
    ranking_bonus_answers_currently_not_visible
    ranking_bonus_answers_help
    x_user_bet
    result_after_game_count
    show_only_today_games
    type_to_filter
    your_statistic
    statistic_for
    show_statistic_for
    ranking_per_game
    ranking_per_game_nothing_to_show
    signed_in_hello
    sign_in
    sign_out
    sign_up
    start_calculating
    save
    compare
    edit
    back
    show
    imprint
    sure
    password_change
    for_got_pw
    change_pw
    set_pw
    send_pw
    save_tip
    create_initial_random_tips
    create_initial_random_tips_description
    comparetips
    hall_of_fame
    no_user
    or
    bonus
    main
    help
    ranking
    notice
    tournament
    tips
    your_tips
    your_bonustips
    back_link
    edit_link
    delete_link
    please_select
    standings
    full_ranking_list
    go_to_bonus_question_page_fill_out
    go_to_bonus_question_page_check
    characters_remaining
  ].freeze

  REQUIRED_BONUS_QUESTION_KEYS = %w[
    which_team_is_champion
    which_team_is_second
    when_final_first_goal
    how_many_goals
  ].freeze

  REQUIRED_FILTER_KEYS = %w[all today future].freeze

  describe 'de locale' do
    subject { I18n.t('.', locale: :de) }

    REQUIRED_APP_KEYS.each do |key|
      it "has key '#{key}'" do
        value = I18n.t(key, locale: :de)
        expect(value).not_to match(/translation missing/i), "Missing key: #{key}"
        expect(value.to_s).not_to be_empty
      end
    end

    REQUIRED_ROUND_KEYS.each do |round|
      it "has round translation for '#{round}'" do
        value = I18n.t("round.#{round}", locale: :de)
        expect(value).not_to match(/translation missing/i)
        expect(value.to_s).not_to be_empty
      end
    end

    REQUIRED_BONUS_QUESTION_KEYS.each do |key|
      it "has bonus_questions.#{key}" do
        value = I18n.t("bonus_questions.#{key}", locale: :de)
        expect(value).not_to match(/translation missing/i)
        expect(value.to_s).not_to be_empty
      end
    end

    REQUIRED_FILTER_KEYS.each do |key|
      it "has filter.#{key}" do
        value = I18n.t("filter.#{key}", locale: :de)
        expect(value).not_to match(/translation missing/i)
        expect(value.to_s).not_to be_empty
      end
    end
  end

  describe 'en locale' do
    REQUIRED_APP_KEYS.each do |key|
      it "has key '#{key}'" do
        value = I18n.t(key, locale: :en)
        expect(value).not_to match(/translation missing/i), "Missing key: #{key}"
        expect(value.to_s).not_to be_empty
      end
    end

    REQUIRED_ROUND_KEYS.each do |round|
      it "has round translation for '#{round}'" do
        value = I18n.t("round.#{round}", locale: :en)
        expect(value).not_to match(/translation missing/i)
        expect(value.to_s).not_to be_empty
      end
    end

    REQUIRED_BONUS_QUESTION_KEYS.each do |key|
      it "has bonus_questions.#{key}" do
        value = I18n.t("bonus_questions.#{key}", locale: :en)
        expect(value).not_to match(/translation missing/i)
        expect(value.to_s).not_to be_empty
      end
    end

    REQUIRED_FILTER_KEYS.each do |key|
      it "has filter.#{key}" do
        value = I18n.t("filter.#{key}", locale: :en)
        expect(value).not_to match(/translation missing/i)
        expect(value.to_s).not_to be_empty
      end
    end

    # No German strings should leak into the English locale.
    # app_name is intentionally "Tippspiel" in both locales (brand name).
    KNOWN_GERMAN_WORDS = %w[bitte deine danke spielen runde achtelfinale viertelfinale
                            halbfinale finale punkte mannschaft turnier bonusfragen].freeze
    SKIP_GERMAN_CHECK_KEYS = %w[app_name].freeze

    it 'contains no untranslated German strings in top-level keys' do
      (REQUIRED_APP_KEYS - SKIP_GERMAN_CHECK_KEYS).each do |key|
        value = I18n.t(key, locale: :en, default: '').to_s.downcase
        KNOWN_GERMAN_WORDS.each do |german_word|
          expect(value).not_to include(german_word),
            "Key '#{key}' in en.yml appears to contain untranslated German: '#{german_word}' found in '#{value}'"
        end
      end
    end
  end

  describe 'en and de have the same round keys' do
    it 'both locales cover all required rounds' do
      REQUIRED_ROUND_KEYS.each do |round|
        de_val = I18n.t("round.#{round}", locale: :de)
        en_val = I18n.t("round.#{round}", locale: :en)
        expect(de_val).not_to match(/translation missing/)
        expect(en_val).not_to match(/translation missing/)
        expect(de_val).not_to eq(en_val), "round.#{round} has identical de/en value — likely not translated"
      end
    end
  end
end
