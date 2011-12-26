require "capistrano_database_yml"

set :application, "Celox"
set :repository,  "git://github.com/johanns/Celox.git"
set :user, "root"
set :use_sudo, false

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :branch, "master"
# Do a fetch instead of clone
set :deploy_via, :remote_cache

# You must chagne the Web server application path to /var/www/celox/current
set :deploy_to, "/var/www/celox/"

role :web, "celox.me"                          # Your HTTP server, Apache/etc
role :db,  "celox.me", :primary => true # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end