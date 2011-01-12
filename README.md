### LolitaCron

Cron daemon for Rails

Built top of:

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
    
    # this is optional
    def self.finished status, error_msg
      case status
      when :success
      when :failed
      end
    end
  end

The "self.finished" is optional, it will be executed after every scheduled task. So you can send bug if task is failed or store 
all results into DB.
Information about time format for "schedule" method you can get at "rufus-scheduler" https://github.com/jmettraux/rufus-scheduler
Some examples:

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

  schedule :every, '5m' do
    puts 'check blood pressure'
  end

### DAEMON USAGE

Start and stop daemon by rake tasks:

  - rake lolita_cron:start
  - rake lolita_cron:stop
