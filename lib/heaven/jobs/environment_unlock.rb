module Heaven
  module Jobs
    class EnvironmentUnlock
      @queue = :locks

      def self.perform(lock_params)
        locker = EnvironmentLocker.new(lock_params)
        locker.unlock!

        status = ::Deployment::Status.new(lock_params[:name_with_owner], lock_params[:deployment_id])
        status.description = "#{locker.name_with_owner} unlocked on #{locker.environment} by #{locker.actor}"

        status.success!
      end
    end
  end
end
