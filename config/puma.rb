workers Integer(ENV['WEB_CONCURRENCY'] || 1)
threads Integer(ENV['MIN_THREADS']  || 1), Integer(ENV['MAX_THREADS'] || 1)

preload_app!

port        ENV['PORT']     or raise 'Please set ENV["PORT"]'
environment ENV['RACK_ENV'] || 'development'

quiet

before_fork do
  ActiveRecord::Base.connection.disconnect!
end

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection

  # Note: The Dalli gem (memcached client) automatically detects
  # shared sockets based on the current PID. We use it in
  # production, but it's not necessary to reconnect here. -Dave
end
