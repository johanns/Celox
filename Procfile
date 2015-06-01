# Recommended for running Puma on a bare-meta or VPS (e.g.: AWS EC2 or Digital Ocean) instance
# See NGINX.md for Nginx sample configuration
# web: bundle exec puma -t 2:16 -w 2 -e ${RAILS_ENV:-development} -b unix:///tmp/celox-puma.sock --pidfile /tmp/celox-puma.pid --control unix:///tmp/celox-pumactl.sock

# Recommended for running Puma on Heroku
web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RAILS_ENV:-development}

# Recommended schedular for non-Heroku deployment (uncomment)
# clock: bundle exec clockwork lib/tasks/clock_cleanup.rb