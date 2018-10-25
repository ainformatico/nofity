SimpleConfig.for :application do
  set :app_name, 'Nofity'
  set :author, 'Alejandro El Informático'
  set :analytics_code, ENV.fetch('GOOGLE_UA')
  set :dashboard_url, 'http://nofity.appme.link/widgets'

  set :git_hash, ENV.fetch('GIT_REV')
end
