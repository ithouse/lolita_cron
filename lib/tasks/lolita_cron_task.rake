require 'fileutils'

namespace :lolita_cron do
  ROOT = "#{RAILS_ROOT}/vendor/plugins/lolita_cron"
  PID_FILE = "#{RAILS_ROOT}/tmp/pids/lolita_cron_#{RAILS_ENV}.pid"
  LOG_FILE = "#{RAILS_ROOT}/log/lolita_cron_#{RAILS_ENV}.log"
  
  desc "Start lolita_cron daemon"
  task :start do
    FileUtils.cd ROOT do
      system "ruby bin/lolita_cron start -e #{RAILS_ENV} --log #{LOG_FILE} --pidfile #{PID_FILE}"
    end
  end

  desc "Stop lolita_cron daemon"
  task :stop do
    FileUtils.cd ROOT do
      system "ruby bin/lolita_cron stop -e #{RAILS_ENV} --log #{LOG_FILE} --pidfile #{PID_FILE}"
    end
  end
end