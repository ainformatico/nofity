group :back do
  use_zeus = File.exist?('.zeus.sock')
  cmd = use_zeus ? 'bundle exec zeus rspec' : 'bundle exec rspec'

  guard :rspec, all_on_start: false, cmd: cmd do
    watch('spec/spec_helper.rb')                       { 'spec' }
    watch('app/controllers/application_controller.rb') { 'spec/controllers' }
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^app/(.+)\.rb$})                          { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/views/(.*)(\.erb|\.haml)$})          { |m| "spec/views/#{m[1]}#{m[2]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb$})                          { |m| "spec/lib/#{m[1]}_spec.rb" }
  end
end

instance_eval(File.read('Guardfile.local')) if File.exist?('Guardfile.local')

guard :jasmine, all_on_start: false do
  watch(%r{spec/javascripts/spec\.(js\.coffee|js|coffee)$}) { 'spec/javascripts' }
  watch(%r{spec/javascripts/.+_spec\.(js\.coffee|js|coffee)$})
  watch(%r{spec/javascripts/fixtures/.+$})
  watch(%r{app/assets/javascripts/(.+?)\.(js\.coffee|js|coffee)(?:\.\w+)*$}) { |m| "spec/javascripts/#{m[1]}_spec.#{m[2]}" }
end

# vim:syntax=ruby
