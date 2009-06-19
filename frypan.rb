gem 'sinatra', '>=0.10.1'
require 'sinatra'
require 'haml'
gem 'oauth'
require 'oauth/consumer'
require 'pp'
# require 'twitter'

module Projectname
  class Application < Sinatra::Application                         

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

    before do
      @consumer = OAuth::Consumer.new "sbZC4BebM68TyBoPZeNw", "jFT3kbruIFki4zryFjrnZvMZx7S2Wz3Fdi1drYOjWk", {:site=>"http://twitter.com"}
      @request_token = @consumer.get_request_token(:oauth_callback => "http://frypan.local/auth")
      
      session[:request_token] = @request_token.token
      session[:request_token_secret] = @request_token.secret
      
    end

    get '/' do
      haml :index
    end
    
    get '/auth' do
      @request_token = OAuth::RequestToken.new(@consumer, session[:request_token], session[:request_token_secret])
      
      @access_token = @request_token.get_access_token(:oauth_verifier =>params[:oauth_verifier])

 
      haml :auth
    end
    
    get '/about' do
      haml :about
    end

    get '/get-started' do
      haml :getstarted
    end
    get '/sign-in-with-twitter' do
      redirect '/oauth-mock/authenticate.html?oauth_token=AILKva982137kasdfasdf98asdf9a7sdfasdf87ads'
    end
    get '/signup' do
      haml :signup
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

  end
end