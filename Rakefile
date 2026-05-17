# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('config/application', __dir__)
require 'rake'
require 'fileutils'
Tippspiel::Application.load_tasks

namespace :tippspiel do
  placeholder_build_date = '###PLACEHOLDER_BUILD_DATE###'
  placeholder_version    = '###PLACEHOLDER_VERSION###'

  desc 'set Versionnumber and Build-Date in normal App-Dir-Structure'
  task :set_version do
    today_date   = Date.today.strftime('%d.%m.%Y') # plain Date.today suffices for a build timestamp; no Rails boot needed
    app_version  = ENV.fetch('APP_VERSION', placeholder_version)
    replacements = { placeholder_build_date => today_date }
    replacements[placeholder_version] = app_version unless app_version == placeholder_version
    set_version_from_file(version_file, replacements)
  end

  def version_file
    File.expand_path('config/version.rb', __dir__)
  end

  def set_version_from_file(version_file, replacements)
    old_file = version_file
    new_file = "#{old_file}.new"
    return unless File.exist?(old_file)

    copy_and_replace(old_file, new_file, replacements)
    File.delete(old_file)
    File.rename(new_file, old_file)
  end

  def copy_and_replace(from_file, to_file, replacements)
    return unless File.exist? from_file

    # check if target exists
    if File.exist? to_file
      backup_file = "#{to_file}.bak"
      puts "Target file #{to_file} already exists, creating backup to #{backup_file}"
      # File.rename to_file, backup_file
      mv to_file, backup_file
    end

    if replacements.blank?
      # nothing to replace, simply copy
      puts "Copy #{from_file} to #{to_file}"
      cp from_file, to_file
    else
      puts "Copy #{from_file} to #{to_file} and replace #{replacements.keys}"
      from = File.open(from_file)
      to = File.new(to_file, 'w')
      from.each do |line|
        replacements.each do |k, v|
          line = line.gsub(k, v) if line.include? k
        end
        to.write(line)
      end
      from.close
      to.close
    end
  end
end
