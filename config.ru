require 'sinatra'
 
# include our Application code
require File.join(File.dirname(__FILE__), 'frypan.rb')
 
# we're in dev mode
set :environment, :development
 
map "/" do
  run Projectname::Application
end