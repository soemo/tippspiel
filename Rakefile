# encoding: utf-8

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
require 'fileutils'
Tippspiel::Application.load_tasks

namespace :tippspiel do
  today_date             = Date.today.strftime('%d.%m.%Y')
  placeholder_build_date = '###PLACEHOLDER_BUILD_DATE###'

  desc 'set Versionnumber and Build-Date in normal App-Dir-Structure'
  task :set_version do
    set_version_from_file(version_file, placeholder_build_date, today_date)
  end

  def version_file
    File.join(Rails.root, 'config/version.rb')
  end

  def set_version_from_file(version_file, placeholder_build_date, today_date)
    old_file = version_file
    new_file    = old_file + '.new'
    if File.exists?(old_file)
      copy_and_replace(old_file, new_file, { placeholder_build_date => today_date })
      File.delete(old_file)
      File.rename(new_file, old_file)
    end
  end

  def copy_and_replace(from_file, to_file, replacements)
    if File.exists? from_file
      # check if target exists
      if File.exists? to_file
        backup_file = to_file + '.bak'
        puts "Target file #{to_file} already exists, creating backup to #{backup_file}"
        #File.rename to_file, backup_file
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
          replacements.each do |k,v|
            if line.include? k
              line = line.gsub(k, v)
            end
          end
          to.write(line)
        end
        from.close
        to.close
      end
    end
  end

end
