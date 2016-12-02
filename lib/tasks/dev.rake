if Rails.env.development? || Rails.env.test?

  namespace :dev do
    desc 'Sample data for local development environment'
    task prime: 'db:setup' do
      load_demo_user_and_random_tips
      set_random_game_goals
    end

    def set_random_game_goals
      games = Game.all
      if games.present?
        games.each do |game|
          game.update_attributes({team1_goals: get_random_goal,
                                  team2_goals: get_random_goal,
                                  finished: true})
        end
      end
    end

    def get_random_goal
      rand(5)
    end

    def load_demo_user_and_random_tips
      100.times.each do |i|
        firstname = "test#{i+1}"
        lastname = 'user'

        # Wenn der Nutzer nicht schon existiert, wird er samt Zufallstipps angelegt
        unless User.exists?(firstname: firstname)
          # gleich als angemeldeter Nutzer anlegen - confirmed_at
          user = User.new({email: "#{firstname}@soemo.org",
                           password: 'testtest',
                           firstname: firstname, lastname: lastname})
          user.confirmed_at = Time.now.utc
          user.confirmation_sent_at = 1.hour.ago
          user.confirm
          puts "Nutzer #{user.name} angelegt"
          if user.present?
            games = Game.all
            if games.present?
              games.each do |game|
                Tip.create!(user: user, game: game, team1_goals: get_random_goal, team2_goals: get_random_goal)
              end
            end
          end
        end
      end
    end
  end
end