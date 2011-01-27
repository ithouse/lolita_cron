# Boot Rails
ENV["RAILS_ENV"] ||= 'development'

require File.expand_path(File.join(File.dirname(__FILE__),'..','..','..','..','..','..','config','boot')) unless defined?(RAILS_ROOT) 

# Load rake tasks, so we can use them in our cron tasks
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'tasks/rails'

# Boot up

ENV['DAEMON_ENV'] ||= ENV["RAILS_ENV"]
require File.join(File.dirname(__FILE__), 'boot')

require 'rubygems'

gem 'daemon-kit', '~> 0.1.8.1'
gem 'eventmachine'
gem 'rufus-scheduler', '~> 2.0.8'

require('ruby-debug') if RAILS_ENV == 'development'

DaemonKit::Initializer.run do |config|
  config.daemon_name = "lolita_cron"
  config.pid_file = "#{RAILS_ROOT}/tmp/pids/lolita_cron_#{DaemonKit.env}.pid"
  config.log_path = "#{RAILS_ROOT}/log/lolita_cron_#{RAILS_ENV}.log"
  config.force_kill_wait = 30
  Rails.logger.level = Logger::Severity::UNKNOWN
end
