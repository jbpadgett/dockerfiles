workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'


app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/tmp"


# Set up socket location
bind "unix://#{shared_dir}/sockets/puma.sock"


# Set master PID and state locations
pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"
# Logging
# Disable if using a process supervisor (runit, supervisord, etc)
stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true


on_worker_boot do
  # Worker specific setup for Rails 4.1+
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  #ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
  ActiveRecord::Base.establish_connection
end


