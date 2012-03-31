FactoryGirl.define do
  factory :game do
    association :team1, :factory => :team
    association :team2, :factory => :team
    team1_goals 0
    team2_goals 0
    place "place"
    round "round"
    start_at DateTime.now
  end

  factory :final, :parent => :game do
    round "final"
  end
end