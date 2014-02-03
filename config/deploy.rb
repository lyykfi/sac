require "bundler/capistrano"

server "174.129.130.28", :web, :app, :db, primary: true 
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "sac.pem")]


set :application, "sac"
set :user, "ec2-user"
set :use_sudo, false
set :deploy_to, "/home/#{user}/sac"
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"


ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :scm, "git"
#set :repository,  "git@github.com:gitgash/#{application}.git"
set :repository,  "/home/komar/devel/#{application}"
set :deploy_via, :copy
set :branch, "master"
#set :branch, "develop"

#set :deploy_via, :remote_cache

set :keep_releases, 5

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
#after "deploy:restart", "deploy:cleanup"
#after "deploy:setup", "deploy:create_release_dir"


# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end
  task :start do
    run "bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end
  #task :create_release_dir, :except => {:no_release => true} do
  #  run "mkdir -p #{fetch :releases_path}"
  #end
#  task :start do ; end
#  task :stop do ; end
#  task :restart, :roles => :app, :except => { :no_release => true } do
#    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#  end
end
