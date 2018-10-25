SimpleConfig.for :application do
  set :dashboard_url, 'http://localhost:3030/widgets'
  set :version, "development - #{`git describe --tags --abbrev=0`.chop}"
  set :git_hash, `git rev-parse --short HEAD`.chop
end
