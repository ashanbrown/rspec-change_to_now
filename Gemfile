source 'https://rubygems.org'

# Specify your gem's dependencies in rspec-change_to_now.gemspec
gemspec

platform :rbx do
  gem 'rubysl'
end

eval File.read('Gemfile-custom') if File.exist?('Gemfile-custom')
