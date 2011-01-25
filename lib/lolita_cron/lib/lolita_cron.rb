module Lolita
  class Cron
    attr_accessor :exception_handler
    class << self
      def instance
        @instance ||= new
      end
      def handle_exception( &block )
        instance.exception_handler = block
      end
      def load_config
        config_file = File.expand_path(RAILS_ROOT+'/config/lolita_cron.rb')
        load(config_file) if File.exists?(config_file)
      end
      def load_tasks
        Dir.glob(RAILS_ROOT + "/lib/crontab/*_task.rb").each do |name|
          task_name = File.basename(name).gsub(".rb","").camelize
          require name
          task_name.constantize
          DaemonKit.logger.info "Registered task: #{task_name}"              
        end          
      end
    end
    
    def handle_exception( job_name, exception )      
      @exception_handler.call( job_name, exception ) unless @exception_handler.nil?
    end
  end
  class CronTask
    class << self
      def schedule method, time, options = {}
        DaemonKit::Cron.scheduler.send(method,time,options) do
          begin
            start = Time.now
            ActiveRecord::Base.connection.reconnect!
            yield
            DaemonKit.logger.info("#{self.name} finished in #{(Time.now - start).round(2)} seconds")
          rescue Exception => exception
            Lolita::Cron.instance.handle_exception self.name, exception
            DaemonKit.logger.error( "Cron: job '#{self.name}' caught exception: '#{"#{exception}\n\n#{$@.join("\n")}"}'" )
          ensure 
            ActiveRecord::Base.connection_pool.release_connection
          end
        end
      end
    end
  end
end
