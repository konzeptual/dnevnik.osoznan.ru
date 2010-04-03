# -*- coding: utf-8 -*-
load 'deploy' if respond_to?(:namespace) # cap2 differentiator

set :application, 'Дневник@осознан.ru'
set :repository, 'git@github.com:krick/dnevnik.osoznan.ru.git'
set :scm, :git
# set :deploy_via, :copy
# set :copy_compression, :gzip
set :use_sudo, false
set :host, 'aldan.konsty.ru'

role :web, host
role :app, host
role :db, host, :primary => true

set :user, 'konsty'

# set(:dest) { Capistrano::CLI.ui.ask("Destination: ") }

set :deploy_to, "/home/#{user}/websites/dnevnik.osoznan.ru"

# before 'deploy:update', 'deploy:update_jekyll'

namespace :deploy do
  
  [:start, :stop, :restart, :finalize_update].each do |t|
    desc "#{t} task is a no-op with jekyll"
    task t, :roles => :app do ; end
  end
  
  # desc 'Run jekyll to update site before uploading'
  # task :update_jekyll do
  #   %x(rm -rf _site/* && jekyll)
  # end
  
end

namespace :jekyll do
  desc "Generates the site on the remote server"
  task :generate_site do
    run "cd #{current_release} && rake site:generate"
  end
  
  desc "Update the jekyll gem"
  task :update_gem do
    run "gem install mattmatt-jekyll"
  end
end

after "deploy:update_code", "jekyll:generate_site"
