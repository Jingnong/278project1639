require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'
set :root, './'
# Setup DataMapper
#DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

# Create Comment class
class Comment
  include DataMapper::Resource
  property :id, Serial
  property :content, String
  property :person, String
  property :created_at, DateTime
end

DataMapper.finalize

# Routes. User who has not logged in will be redirected to login page.
get '/comments' do
  redirect("/login") unless session[:admin]
  @comments = Comment.all
  erb :comments
end

get '/comments/new' do
  redirect("/login") unless session[:admin]
  @comments = Comment.new
  erb :new_comment
end

get '/comments/:id' do
  redirect("/login") unless session[:admin]
  @comments = Comment.get(params[:id])
  erb :show_comment
end

post '/comments' do  
  redirect("/login") unless session[:admin]
  comments = Comment.create(params['comments'])
  redirect to("/comments/#{comments.id}")
end

put '/comments/:id' do
  redirect("/login") unless session[:admin]
  comments = Comment.get(params[:id])
  comments.update(params['comments'])
  redirect to("/comments/#{comments.id}")
end

delete '/comments/:id' do
  redirect("/login") unless session[:admin]
  Comment.get(params[:id]).destroy
  redirect to('/comments')
end
