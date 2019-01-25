require 'sinatra'
require 'sinatra/reloader'
require 'byebug'

get '/' do
  erb :'memos/index'
end

get '/memos' do
  erb :'memos/index'
end

get '/memos/new' do
  erb :'memos/new'
end
