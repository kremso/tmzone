require 'bundler/capistrano'

set :application, "tmzone"
set :repository,  "git@gitbus.fiit.stuba.sk:tmzone/tmzone.git"
set :scm, :git

ssh_options[:forward_agent] = true

set :user, "minio"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :rails_env, "production"
set :use_sudo, false
server "minio-beta.customserver.sk", :app, :web, :db, :primary => true

namespace :deploy do
  task :restart, :roles => :web do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after "deploy:restart", "deploy:cleanup"
