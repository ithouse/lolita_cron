require 'erb'
LOLITA_CRON_ROOT = "#{RAILS_ROOT}/vendor/plugins/lolita_cron"

namespace :lolita_cron do
  desc "Generate god config file"
  task :gen_god => 'environment' do
    require "#{LOLITA_CRON_ROOT}/lib/lolita_cron/config/environment"
    name = DaemonKit.configuration.daemon_name
    env  = DaemonKit.env
    File.open("#{RAILS_ROOT}/config/#{name}_#{env}.god", "w+" ) do |f|
      t = File.read("#{LOLITA_CRON_ROOT}/templates/god/god.erb")
      f.write(ERB.new(t).result(binding))
    end

    puts "god config generated in config/#{name}_#{env}.god"
    puts "UPDATE email specific information at the bottom of the file."
  end
end
