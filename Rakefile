# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Tippspiel::Application.load_tasks

namespace :tippspiel do

  desc "Build Tippspiel with Tests, Specs, and Doc"
  task :build => [:init, 'db:migrate', 'doc:app']

  desc "Init Tippspiel"
  task :init do
    makedirs "tmp"
    makedirs "log"
    makedirs 'doc/app'
    ENV["RAILS_ENV"] = "test"
    puts Date.today.strftime("%d.%m.%Y") + " init Tippspiel Build"
    ENV["PATH"] = ENV["PATH"] + ":#{Rails.root}/vendor/bundle/ruby/1.8/bin"
    system("bundle install --deployment") # das benoetigt Bundler, damit er anschliessend alles findet
  end



end
