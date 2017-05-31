require 'dm-core'
require 'dm-migrations'
set :root, './'
# Setup DataMapper
#DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

#Create Student class
class Student
  include DataMapper::Resource
  property :id, Serial
  property :firstname, String, :required => true
  property :lastname, String, :required => true
  property :address, String, :required => true
  property :birthday, Date, :required => true
end

# Configuration
configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

DataMapper.finalize

# Routes. User who has not logged in will be redirected to login page.
get '/students' do
  redirect("/login") unless session[:admin]
  @students = Student.all
  erb :students
end

get '/students/new' do
  redirect("/login") unless session[:admin]
  @students = Student.new
  erb :new_student
end

get '/students/:id' do
  redirect("/login") unless session[:admin]
  @students = Student.get(params[:id])
  erb :show_student
end

get '/students/:id/edit' do
  redirect("/login") unless session[:admin]
  @students = Student.get(params[:id])
  erb :edit_student
end

post '/students' do  
  redirect("/login") unless session[:admin]
  students = Student.create(params['students'])
  redirect to("/students/#{students.id}")
end

put '/students/:id' do
  redirect("/login") unless session[:admin]
  students = Student.get(params[:id])
  students.update(params['students'])
  redirect to("/students/#{students.id}")
end

delete '/students/:id' do
  redirect("/login") unless session[:admin]
  Student.get(params[:id]).destroy
  redirect to('/students')
end
