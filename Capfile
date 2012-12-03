load 'deploy'
load 'deploy/assets'

set :pg_config_path, File.expand_path(File.dirname(__FILE__), 'config')

require 'capistrano-zen/utils'
require 'capistrano-zen/nginx'
require 'capistrano-zen/nodejs'
require 'capistrano-zen/postgresql'
require 'capistrano-zen/rbenv'
require 'capistrano-zen/unicorn'

# Use Git as Version Control System
set :scm, :git
set :repository, "git@github.com:yangchenyun/gitlabhq.git"
set :branch, 'deploy'

# keep a remote cache to avoid checking out everytime
set :deploy_via, :remote_cache

# enable prompt for password
default_run_options[:pty] = true

# try_sudo will not use sudo by default
set :use_sudo, false

# access github.com using as the local user
ssh_options[:forward_agent] = true
set :user, 'gitlab'
set :group, 'gitlab'

set :application, "gitlab"

set :unicorn_workers, 2

set :use_resque, true

task :production do
  set :domain, "git.zenhacks.org"
  # lua - 42.121.3.105, aliyun - steven
  server '42.121.3.105', :web, :app, :db, :primary => true
  set :deploy_to, "/home/#{user}/repositories/#{application}-production"
end

namespace :gitlab do
  task :setup, roles: :app do
    upload "./config/gitlab.yml", "#{shared_path}/config/gitlab.yml"
    run "#{sudo} -u gitlab bundle exec rake gitlab:app:setup RAILS_ENV=production"
  end

  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/gitlab.yml #{release_path}/config/gitlab.yml"
  end

  task :status, roles: :app do
    run "#{sudo} -u gitlab bundle exec rake gitlab:app:status RAILS_ENV=production"
  end
end

namespace :deploy do
  # start/stop/restart application
  task :start, :roles => :app, :except => { :no_release => true } do
  	unicorn.start
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
  	unicorn.stop
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
  	unicorn.upgrade
  end

  task :bundle, :roles => :app, :except => { :no_release => true } do
    run "cd #{release_path} && bundle install"
  end
  after "deploy:finalize_update", "deploy:bundle"
end

after "deploy:setup",
  "nginx:setup:unicorn",
  "pg:setup",
  "pg:init",
  "unicorn:setup"

after "deploy:finalize_update", "pg:symlink", "gitlab:symlink"
