require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb :'memos/index'
end

get '/memos' do
  erb :'memos/index'
end

get '/memos/new' do
  erb :'memos/new'
end
