module SilenceQueries
  def silence_queries
    previous_level = ::ActiveRecord::Base.logger.level
    ::ActiveRecord::Base.logger.level = Logger::WARN if previous_level < Logger::WARN
    yield
  ensure
    ::ActiveRecord::Base.logger.level = previous_level
  end
end
