require "bundler/capistrano"

server "54.224.205.171", :web, :app, :db, primary: true
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "sac.pem")]


set :application,  "sac"
set :user,         "ec2-user"
set :use_sudo,     false
set :deploy_to,    "/home/#{user}/sac"
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid,  "#{deploy_to}/shared/pids/unicorn.pid"
set :start_cmd,    "bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"

ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :scm, "git"

# set :repository,  "git@github.com:gitgash/#{application}.git"
# set :branch,      "master"
# set :deploy_via,  :remote_cache

set :repository,  ENV["HOME"] + "/projects/SitCenter/rails/sac"
set :branch,      "mtungusov"

set :deploy_via,  :copy
# set :copy_cache, true
set :copy_exclude, %w(.git .gitignore)

# set :deploy_via, :copyset :branch, "master"

set :keep_releases, 5

# Setup Database
namespace :database do
  desc "Make link on database.yml"
  task :yml, :roles => :app do
    run "ln -fs #{shared_path}/database.yml #{release_path}/config/database.yml"
  end
end

desc "Make link on logs dir"
task :link_logs_dir, :roles => :app do
  run "rm -rf #{release_path}/log; ln -s #{shared_path}/log/ #{release_path}/log"
end

desc "Make link on extjs dir"
task :link_extjs_dir, :roles => :app do
  run "ln -fs #{shared_path}/ext-4.1.1a #{release_path}/public/extjs"
end

namespace :deploy do
  desc "Start unicorn"
  task :start do
    run "cd #{deploy_to}/current && #{start_cmd}"
  end

  desc "Stop unicorn"
  task :stop do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end

  desc "Restart unicorn"
  task :restart do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && #{start_cmd}; fi"
  end
end

after "deploy:update_code", :link_logs_dir
after "deploy:update_code", :link_extjs_dir
after "deploy:update_code", "database:yml"
# after "database:yml",       "deploy:migrate"
# load 'deploy/assets'