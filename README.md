### LolitaCron

Cron alike daemon for Rails.

Runs on:

  - https://github.com/kennethkalmer/daemon-kit
  - https://github.com/jmettraux/rufus-scheduler

### INSTALL

  - ruby script/plugin install git://github.com/ithouse/lolita_cron.git
  - Create directory "lib/crontab" for your tasks

### CONFIGURATION

Add cron tasks into directory "lib/crontab", rules:
  
  - filename should be lowercased classname, like "rss_feed_task.rb"
  - filename should end with "_task.rb"
  - file should contain class with camelized filename, like "RssFeedTask"
  - class should extend Lolita::CronTask
  - class can have many "schedule" block
  
  Example:
  
    class RssFeedTask < Lolita::CronTask
      schedule :cron '0 22 * * 1-5' do
        # every day of the week at 22:00 (10pm)
        RssFeed.run
      end
    end

Information about time format for "schedule" method you can get at "rufus-scheduler" https://github.com/jmettraux/rufus-scheduler. Some examples:

    schedule :every, '5m' do
      puts 'check blood pressure'
    end
    
    schedule :in, '20m' do
      puts "order ristretto"
    end
  
  
    schedule :at, 'Thu Mar 26 07:31:43 +0900 2009' do
      puts 'order pizza'
    end
  
    schedule :cron, '0 22 * * 1-5' do
      # every day of the week at 22:00 (10pm)
      puts 'activate security system'
    end

### OVERRIDE SETTINGS

You can create "config/lolita_cron.rb" and change LolitaCron behavior.

##### Handle exceptions

Add this to "config/lolita_cron.rb" and send exception as email.

    Lolita::Cron.handle_exception do |job_name, exception|
      msg = "#{"#{exception}\n\n#{$@.join("\n")}"}"
      # deliver_bug "lolita_cron task #{job_name} failed", msg
    end

### DAEMON USAGE

Start and stop daemon by rake tasks:

  - rake lolita_cron:start
  - rake lolita_cron:stop
  - rake lolita_cron:restart
  
### CAPISTRANO

    namespace :lolita_cron do
      desc "Stop LolitaCron Daemon"
      task :stop, :roles => :app do
        rails_env = fetch(:rails_env, "staging")
        run "cd #{previous_release} && if [ -d lib/crontab/ ] ; then rake RAILS_ENV=#{rails_env} lolita_cron:stop ; fi"
      end
      desc "Start LolitaCron Daemon"
      task :start, :roles => :app do
        rails_env = fetch(:rails_env, "staging")
        run "cd #{current_path} && if [ -d lib/crontab/ ] ; then rake RAILS_ENV=#{rails_env} lolita_cron:start ; fi"
      end
    end
    after "deploy:update_code", "lolita_cron:stop"
    after "deploy:cleanup", "lolita_cron:start"
