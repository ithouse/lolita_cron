module Lolita
  class CronTask
    class << self
      def schedule method, time
        DaemonKit::Cron.scheduler.send(method,time) do
          begin
            ActiveRecord::Base.connection.reconnect!
            yield
            task_finished :success, nil
          rescue Exception => e
            task_finished :failed, "#{e}\n\n#{$@.join("\n")}"
          ensure
            ActiveRecord::Base.connection_pool.release_connection
          end
        end
      end
      
      private
      
      def task_finished status, error_msg
        case status
        when :success
          DaemonKit.logger.debug "#{self.name} success #{Time.now}"
        when :failed
          DaemonKit.logger.debug "#{self.name} failed #{Time.now}"
        end
        if self.respond_to?(:finished)
          self.finished(status, error_msg)
        end
      end
    end
  end
end
