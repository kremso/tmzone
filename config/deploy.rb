require 'bundler/capistrano'

set :application, "tmzone"
set :repository,  "git@gitbus.fiit.stuba.sk:tmzone/tmzone.git"
set :scm, :git

ssh_options[:forward_agent] = true

set :user, "ror"
set :deploy_to, "/home/#{user}/webapps/#{application}"
set :rails_env, "staging"
set :use_sudo, false
server "nimbus.fiit.stuba.sk", :app, :web, :db, :primary => true

set :rvm_ruby_string, '1.9.3@tmzone'
before 'deploy:setup', 'rvm:install_rvm'   # install RVM
before 'deploy:setup', 'rvm:install_ruby'  # install Ruby and create gemset, or:
before 'deploy:setup', 'rvm:create_gemset' # only create gemset

require 'rvm/capistrano'

set :shared_children, shared_children << 'tmp/sockets'

namespace :deploy do
  desc "Symlink shared"
  task :symlink_shared do
    run "ln -nfs #{shared_path} #{release_path}/shared"
  end

  desc "Start the application"
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec puma -p 9292 -b 'unix://#{shared_path}/sockets/puma.sock' -S #{shared_path}/sockets/puma.state --control 'unix://#{shared_path}/sockets/pumactl.sock' >> #{shared_path}/log/puma-#{rails_env}.log 2>&1 &", :pty => false
  end

  desc "Stop the application"
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec pumactl -S #{shared_path}/sockets/puma.state stop"
  end

  desc "Restart the application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec pumactl -S #{shared_path}/sockets/puma.state restart"
  end
end

after "deploy:restart", "deploy:cleanup"
after "deploy:update_code", "deploy:symlink_shared"
