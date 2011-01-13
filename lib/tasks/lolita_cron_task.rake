require 'fileutils'

namespace :lolita_cron do
  ROOT = "#{RAILS_ROOT}/vendor/plugins/lolita_cron"
  LOG_FILE = "#{RAILS_ROOT}/log/lolita_cron_#{RAILS_ENV}.log"
  
  desc "Start lolita_cron daemon"
  task :start do
    FileUtils.cd ROOT do
      system "ruby bin/lolita_cron start -e #{RAILS_ENV} --log #{LOG_FILE}"
    end
  end

  desc "Stop lolita_cron daemon"
  task :stop do
    FileUtils.cd ROOT do
      system "ruby bin/lolita_cron stop -e #{RAILS_ENV} --log #{LOG_FILE}"
    end
  end
  
  desc "Restart lolita_cron daemon"
  task :restart do
    Rake::Task["lolita_cron:stop"].invoke
    Rake::Task["lolita_cron:start"].invoke   
  end
end