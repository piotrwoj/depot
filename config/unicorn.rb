# Set the working application directory
# working_directory "/path/to/your/app"
working_directory "/app/depot/current"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
#pid "/app/depot/current/tmp/pids/unicorn.pid"
pid "/app/depot/shared/unicorn.pid"

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path "/app/depot/current/log/unicorn.log"
stdout_path "/app/depot/current/log/unicorn.log"

# Unicorn socket
#listen "/tmp/unicorn.[app name].sock"
listen "/app/depot/current/tmp/sockets/unicorn.depot.sock"

# Number of processes
# worker_processes 4
worker_processes 2

# Time-out
timeout 30
