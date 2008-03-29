set :application, "twittersign"
set :repository, "http://svn.integrum.beanstalkapp.com/twittersign/trunk"

server = ENV['SERVER'] || 'erbium.integrumtech.com'

role :web, server
role :app, server
role :db,  server, :primary => true

set :user, "integrum"
set :use_sudo, false

set :deploy_to, "/home/integrum/apps/#{application}"
set :config_dir, "#{deploy_to}/config"
set :backup_dir, "#{deploy_to}/backup"


task :after_update_code do
  run <<-EOC
    cp #{config_dir}/* #{release_path}/config &&
    ln -nfs #{shared_path}/db/* #{release_path}/db
  EOC
end

deploy.task :restart do
  sudo "svc -d /service/#{application}_bot"
  sudo "svc -d /service/#{application}"
  sudo "svc -u /service/#{application}_bot"
  sudo "svc -u /service/#{application}"
end

deploy.task :start do
  sudo "svc -u /service/#{application}"
  sudo "svc -u /service/#{application}_bot"
end

deploy.task :stop do
  sudo "svc -d /service/#{application}"
  sudo "svc -d /service/#{application}_bot"
end
