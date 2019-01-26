require 'sinatra'
require 'sinatra/reloader'
require_relative './models/memo.rb'
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

post '/memos' do
  @memo_title = params[:memo_contents].lines[0]
  @memo_content = params[:memo_contents].lines[1..-1].join
  if @memo_title.gsub(/^[[:space:]]+/, '').empty?
    puts "空白文字のみのタイトルは禁止されています。"
  else
    #csvファイルへの保存処理
    @memo = Memo.new(@memo_title, @memo_content)
    @memo.save
  end
  redirect '/memos/:id'
end
