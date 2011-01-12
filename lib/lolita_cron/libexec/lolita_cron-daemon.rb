# Generated cron daemon

# Do your post daemonization configuration here
# At minimum you need just the first line (without the block), or a lot
# of strange things might start happening...
DaemonKit::Application.running! do |config|
  # Trap signals with blocks or procs
  # config.trap( 'INT' ) do
  #   # do something clever
  # end
  # config.trap( 'TERM', Proc.new { puts 'Going down' } )
end
DaemonKit::EM.run

# Load lolita_cron.rb Rails config file
Lolita::Cron::load_config

# Load cron tasks
Lolita::Cron::load_tasks

# Run our 'cron' dameon, suspending the current thread
DaemonKit::Cron.run
