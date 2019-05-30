# frozen_string_literal: true

module Coverband
  class AtExit
    @semaphore = Mutex.new

    @at_exit_registered = nil
    def self.register
      return if ENV['COVERBAND_DISABLE_AT_EXIT']
      return if @at_exit_registered

      @semaphore.synchronize do
        return if @at_exit_registered

        @at_exit_registered = true
        at_exit do
          ::Coverband::Background.stop

          if !Coverband.configuration.report_on_exit
            # skip reporting
          else
            Coverband.report_coverage
          end
        end
      end
    end
  end
end
