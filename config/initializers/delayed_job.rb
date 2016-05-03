require 'delayed_job_class_reloader'
require 'silence_queries'

Delayed::Worker.delay_jobs = !Rails.env.test?
Delayed::Worker.destroy_failed_jobs = false

unless Rails.application.config.cache_classes
  Delayed::Worker.plugins << DelayedJobClassReloader
end

module DelayedJobSilencer
  def reserve(*)
    silence_queries do
      super
    end
  end
end

class << Delayed::Backend::ActiveRecord::Job
  include SilenceQueries
  prepend DelayedJobSilencer
end
