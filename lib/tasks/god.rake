require 'erb'

LOLITA_CRON_ROOT = "#{RAILS_ROOT}/vendor/plugins/lolita_cron"

namespace :lolita_cron do
  desc "Generate god config file"
  task :gen_god => 'environment' do    
    require "#{LOLITA_CRON_ROOT}/lib/lolita_cron/config/environment"
    name = DaemonKit.configuration.daemon_name
    env  = DaemonKit.env
    t = File.read("#{LOLITA_CRON_ROOT}/templates/god/god.erb")
    puts ERB.new(t).result(binding)
  end
end
