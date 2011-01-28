begin
  require 'rufus/scheduler'
rescue LoadError => e
  $stderr.puts "Missing rufus-scheduler gem. Please run 'bundle install'."
  exit 1
end

if Rufus::Scheduler::VERSION < "2.0.0"
  $stderr.puts "Requires rufus-scheduler-2.0.0 or later"
  exit 1
end

# Monkeypatch - to run daemons for many environments on the same server
module DaemonKit
  class Initializer
    def include_core_lib
      if File.exists?( core_lib = File.join( DAEMON_ROOT, 'lib', 'lolita_cron.rb' ) )
        require core_lib
      end
    end
  end
end