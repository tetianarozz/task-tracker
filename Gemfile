source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'active_model_serializers', '~> 0.10.14'
gem 'bootsnap', require: false
gem 'enumerize', '~> 2.7'
gem 'importmap-rails'
gem 'jbuilder'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.8'
gem 'redis', '~> 4.0'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'database_cleaner-active_record', '~> 2.1'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.3'
  gem 'faker', '~> 3.2', '>= 3.2.3'
  gem 'rspec-rails', '~> 6.1', '>= 6.1.1'
  gem 'rubocop', '~> 1.60', '>= 1.60.2'
  gem 'rubocop-performance', '~> 1.20', '>= 1.20.2'
  gem 'rubocop-rails', '~> 2.23', '>= 2.23.1'
  gem 'rubocop-rspec', '~> 2.26', '>= 2.26.1'
end

group :development do
  gem 'web-console'
end
