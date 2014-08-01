source 'https://rubygems.org'

# Specify your gem's dependencies in rspec-change_to_now.gemspec
gemspec

%w[rspec rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
  branch = ENV.fetch('BRANCH','master')
  next if branch == '2-99-maintenance' && lib == 'rspec-support'
  library_path = File.expand_path("../../#{lib}", __FILE__)
  if File.exist?(library_path)
    gem lib, :path => library_path
  else
    gem lib, :git => "git://github.com/rspec/#{lib}.git",
             :branch => branch
  end
end

# test coverage
# gem 'simplecov', :require => false

gem 'coveralls', :require => false, :platform => :mri_20

eval File.read('Gemfile-custom') if File.exist?('Gemfile-custom')

platform :rbx do
  gem 'rubysl'
end
