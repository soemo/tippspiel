if Rails.env.development? || Rails.env.test?

  namespace :dev do
    desc 'Sample data for local development environment'
    task prime: 'db:setup' do
      load_demo_user_with_random_tips
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

    def load_demo_user_with_random_tips
      100.times.each do |i|
        firstname = "test#{i+1}"
        lastname = 'user'

        # Wenn der Nutzer nicht schon existiert, wird er samt Zufallstipps angelegt
        unless User.exists?(firstname: firstname)
          # gleich als angemeldeter Nutzer anlegen - confirmed_at
          user = User.create({email: "#{firstname}@soemo.org",
                              password: 'testtest',
                              create_initial_random_tips: true,
                              firstname: firstname,
                              lastname: lastname,
                              confirmed_at: Time.now.utc,
                              confirmation_sent_at: 1.hour.ago})
          user.confirm
          puts "Nutzer #{user.name} angelegt - gets randoms tips on first login"
        end
      end
    end
  end
end