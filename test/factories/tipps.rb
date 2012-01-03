FactoryGirl.define do
  factory :tipp do
    user_id {User.first.id}
    game_id {Game.first.id}
    team1_tore 0
    team2_tore 0
  end
end