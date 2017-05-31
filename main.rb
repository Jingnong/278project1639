require 'sinatra'
#require 'sinatra/reloader'
require 'sass'
require './students'
require './comments'
set :root, './'
# Configuration
configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

# Setup database
configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
  DataMapper.auto_upgrade!
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
  DataMapper.auto_upgrade!
end

# Link style file
get('/styles.scss'){ scss :styles }

# Routes. User who has not logged in will be redirected to login page.
get '/' do
  #redirect("/login") unless session[:admin]
  erb :home
end

get '/login' do
  erb :login
end

# Check the username and password, redirect authorized to home page.
post "/login" do
  if params["login"]["username"] == 'frank' && params['login']['password'] == "sinatra"
    session[:admin] = true
    redirect to ("/")
  else
    erb :login
  end
end

# Change the session after user has logged out.
get "/logout" do
  session[:admin] = nil
  redirect to ("/")
end

get '/about' do
  redirect("/login") unless session[:admin]
  @title = "All About This Website"
  erb :about
end

get '/contact' do
  redirect("/login") unless session[:admin]
  erb :contact
end

get '/video' do
  redirect("/login") unless session[:admin]
  erb :video
end

not_found do
  erb :not_found
end
