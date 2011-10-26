require 'faker'

namespace :db do
  desc "Data maker"
  task :propagate => :environment do
    Rake::Task['db:reset'].invoke
    User.create!(:name => "tester",
                 :email => "t@t.t",
                 :password => "tttttt",
                 :password_confirmation => "tttttt")
    User.connection.update("UPDATE users SET admin=true WHERE id=1")
    Flag.connection.insert("INSERT INTO flags (id, flag_name, flag_value, created_at)
                                      VALUES(1, 'construct', false, '#{Time.now.to_formatted_s(:db)}')")
    
    99.times do |n|
      # name = Faker::Name.name
      name = "user_#{n+1}"
      email = "user_#{n+1}@test.t"
      password  = "tttttt"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
  end
end