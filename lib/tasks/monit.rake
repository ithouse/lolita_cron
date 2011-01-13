require 'erb'
LOLITA_CRON_ROOT = "#{RAILS_ROOT}/vendor/plugins/lolita_cron"

namespace :lolita_cron do
  desc "Generate monit config file"
  task :gen_monit => 'environment' do
    require "#{LOLITA_CRON_ROOT}/lib/lolita_cron/config/environment"
    env  = DaemonKit.env
    File.open("#{RAILS_ROOT}/config/monit_#{env}.conf", "w+") do |f|
      t = File.read("#{LOLITA_CRON_ROOT}/templates/monit/monit.erb")
      f.write(ERB.new(t).result(binding))
    end

    puts "Monit config generated in config/monit_#{env}.conf"
  end
end
