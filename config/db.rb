ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
  :host     => "localhost",
  :username => "root",
  :password => "",
  :database => "frypan"
)

unless ActiveRecord::Base.connection.tables.include?('users')
  puts "Creating users table..."
  ActiveRecord::Base.connection.create_table("users") do |t|
    t.string "email"
    t.string "twitter_screen_name"
    t.string "twitter_user_id"
    t.string "twitter_oauth_token"
    t.string "twitter_oauth_token_secret"
    t.string "password"
    t.string "openid"
  end
end
