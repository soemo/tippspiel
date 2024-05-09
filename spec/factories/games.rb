# -*- encoding : utf-8 -*-
FactoryBot.define do
  factory :game do
    team1 do
      case @build_strategy
        when FactoryBot::Strategy::Create then FactoryBot.create(:team)
        when FactoryBot::Strategy::Build then FactoryBot.build(:team)
        when FactoryBot::Strategy::Stub then FactoryBot.build_stubbed(:team)
      end
    end
    team2 do
      case @build_strategy
        when FactoryBot::Strategy::Create then FactoryBot.create(:team)
        when FactoryBot::Strategy::Build then FactoryBot.build(:team)
        when FactoryBot::Strategy::Stub then FactoryBot.build_stubbed(:team)
      end
    end
    team1_goals { 0 }
    team2_goals { 0 }
    place { "place" }
    round { "round" }
    start_at { DateTime.now }
    finished { false }
  end

  factory :final, :parent => :game do
    round { "final" }
  end
end
