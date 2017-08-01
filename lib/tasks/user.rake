namespace :user do
  desc "creates users"
  task :create, [:email] => :environment do |t, args|
    UserCreationService.new(email: args[:email]).save
  end
end
