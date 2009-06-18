gem 'sinatra', '>=0.10.1'
require 'sinatra'
require 'haml'
require 'twitter'

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

    get '/' do
      haml :index
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