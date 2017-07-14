source 'https://rubygems.org'

ruby File.read('.ruby-version').chomp

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.0.2'
gem 'pg', '0.19.0'
gem 'puma', '3.7.1'
gem 'jsonapi-resources', '0.9.0'
gem 'knock'
gem 'bcrypt'
gem 'rack-cors'

group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'pry-rails', '~> 0.3.6'
  gem 'dotenv-rails', '2.2.0'
  gem 'pry-byebug'
end

group :development do
  gem 'listen', '3.0.8'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '2.0.1'
  gem 'spring-watcher-listen', '2.0.1'
end

group :test do
  gem 'timecop'
  gem 'rspec-rails', '3.5.2'
  gem 'database_cleaner', '1.5.3'
  gem 'simplecov', '0.14.1', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '1.2.2', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
