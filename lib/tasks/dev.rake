if Rails.env.development? || Rails.env.test?

  namespace :dev do
    desc 'Sample data for local development environment'
    task prime: 'db:setup' do
      load_demo_user_with_random_tips
      set_random_game_goals
    end

    desc 'Mark the first N games as finished and recalculate rankings. Usage: rake dev:finish_games[10] or COUNT=10 rake dev:finish_games'
    task :finish_games, [:count] => :environment do |_t, args|
      count = (args[:count] || ENV['COUNT'] || 5).to_i

      # Reset all games to unfinished first
      Game.update_all(finished: false)
      puts "Reset all games to unfinished."

      # Mark the first N games (ordered by start_at) as finished
      games_to_finish = Game.order(start_at: :asc).limit(count)
      games_to_finish.update_all(finished: true)
      puts "Marked #{games_to_finish.size} games as finished."

      # Run the full ranking pipeline
      puts "Running ranking calculation..."
      Tips::UpdatePoints.call
      Users::UpdatePoints.call
      Users::UpdateRankingPerGame.call
      puts "Done. Visit /statistics to see the chart with #{count} games."
    end

    def set_random_game_goals
      games = Game.all
      if games.present?
        games.each do |game|
          game.update({team1_goals: get_random_goal,
                                team2_goals: get_random_goal,
                                finished: false})
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
                              password: 'testtesttippspiel',
                              create_initial_random_tips: true,
                              firstname: firstname,
                              lastname: lastname,
                              confirmed_at: Time.now.utc,
                              confirmation_sent_at: 1.hour.ago})
          user.confirm

          # Tips are normally created on first login — trigger directly here for dev setup
          Tips::FromUser.call(user_id: user.id)
          puts "Nutzer #{user.name} angelegt mit Zufallstipps"
        end
      end
    end
  end
end