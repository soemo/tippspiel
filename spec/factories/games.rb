# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :game do
    team1 do
      case @build_strategy
        when FactoryGirl::Strategy::Create then FactoryGirl.create(:team)
        when FactoryGirl::Strategy::Build then FactoryGirl.build(:team)
        when FactoryGirl::Strategy::Stub then FactoryGirl.build_stubbed(:team)
      end
    end
    team2 do
      case @build_strategy
        when FactoryGirl::Strategy::Create then FactoryGirl.create(:team)
        when FactoryGirl::Strategy::Build then FactoryGirl.build(:team)
        when FactoryGirl::Strategy::Stub then FactoryGirl.build_stubbed(:team)
      end
    end
    team1_goals 0
    team2_goals 0
    place "place"
    round "round"
    start_at DateTime.now
    finished false
    sequence(:api_match_id){|n| n }
  end

  factory :final, :parent => :game do
    round "final"
  end
end
