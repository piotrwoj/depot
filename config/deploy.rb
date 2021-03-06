# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'depot'
set :repo_url, 'git@github.com:piotrwoj/depot.git'
set :rbenv_custom_path, '/home/app/.rbenv'
set :rbenv_ruby, '2.1.5'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/app/depot'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  task :restart do
    on roles(:web, :app, :db) do
      #execute "mkdir /app/depot/current/tmp; mkdir /app/depot/current/tmp/pids; mkdir /app/depot/current/tmp/sockets" # w koncu require 'capistrano/rails/assets' to robi
      execute "ln -sf #{fetch :deploy_to}/current/config/nginx.conf /etc/nginx/sites-enabled/depot" #gdy uzytkownik rootem
      execute "chmod a+x #{fetch :deploy_to}/current/config/unicorn_init.sh"
      execute "ln -sf #{fetch :deploy_to}/current/config/unicorn_init.sh /etc/init.d/unicorn_depot" #gdy uzytkownik rootem
      #execute "cp #{fetch :deploy_to}/current/config/unicorn_init.sh #{fetch :deploy_to}/shared"
      #execute "cp #{fetch :deploy_to}/current/config/nginx.conf #{fetch :deploy_to}/shared"
      execute "chown -R app #{fetch :deploy_to}"
      execute "service unicorn_depot restart; service nginx restart"
    end
  end

  after :publishing, :restart

end
