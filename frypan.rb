gem 'sinatra', '>=0.10.1'
require 'sinatra'
require 'haml'
gem 'oauth'
require 'oauth/consumer'
require 'pp'
require 'active_record'
require 'config/db'
require 'models/users'

module Frypan
  class Application < Sinatra::Application                         
    
    enable :sessions
    set :site_root, '/'
    set :haml, {:format => :html4}  # default Haml format is :xhtml

    def partial(name)
      haml(:"_#{name}", :layout => false)
    end
    def path_to_stylesheet(stylesheet)
      options.site_root + "css/#{stylesheet}.css?" + File.mtime(File.join(options.public,"css/#{stylesheet}.css")).to_i.to_s
    end
    def path_to_image(image)
      options.site_root + "images/#{image}?" + File.mtime(File.join(options.public,"images/#{image}")).to_i.to_s
    end
    def path_to_javascript(js)
      options.site_root + "js/#{js}.js?" + File.mtime(File.join(options.public,"js/#{js}.js")).to_i.to_s
    end
    def path_to_page(page)
      options.site_root + "#{page}"
    end
    def do_oauth_dance
      @request_token = @consumer.get_request_token(:oauth_callback => "http://frypan.local/signup")
      session[:request_token] = @request_token.token
      session[:request_token_secret] = @request_token.secret
    end

    before do
      @consumer = OAuth::Consumer.new "sbZC4BebM68TyBoPZeNw", "jFT3kbruIFki4zryFjrnZvMZx7S2Wz3Fdi1drYOjWk", {:site=>"http://twitter.com"}
    end

    get '/' do
      do_oauth_dance
      haml :index
    end
    get '/get-started' do
      do_oauth_dance
      haml :getstarted
    end
    get '/signup' do
      @access_token = OAuth::RequestToken.new(@consumer, session[:request_token], session[:request_token_secret]).get_access_token(:oauth_verifier =>params[:oauth_verifier])
      @user = User.new
      haml :signup
    end
    post '/create' do
      @user = User.new(params[:user])
      @user.twitter_screen_name = session[:access_token][:screen_name]
      @user.twitter_user_id = session[:access_token][:user_id]
      @user.twitter_oauth_token = session[:access_token][:oauth_token]
      @user.twitter_oauth_token_secret = session[:access_token][:oauth_token_secret]

      if @user.valid? && @user.save!
        redirect "/thank-you"
      else
        haml :signup
      end
    end
    
    get '/about' do
      haml :about
    end
    get '/thank-you' do
      haml :signup_confirmation
    end

    get '/login' do
      haml :login
    end
    get '/logout' do
      redirect '/#not_logged_in'
    end

    get '/account' do
      haml :account
    end
    get '/followers' do
      @date = Date.today
      haml :followers
    end

    get '/email' do
      haml :email, :layout => false
    end

  end
end