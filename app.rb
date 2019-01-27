require 'sinatra'
require 'sinatra/reloader'
require_relative './models/memo.rb'
require 'byebug'

get '/' do
  memo_hash = Memo.all
  erb :'memos/index', :locals => {:memo_hash => memo_hash}
end

get '/memos' do
  memo_hash = Memo.all
  erb :'memos/index', :locals => {:memo_hash => memo_hash}
end

get '/memos/new' do
  erb :'memos/new'
end

post '/memos' do
  memo_title = params[:memo_contents].lines[0]
  memo_content = params[:memo_contents].lines[1..-1].join
  if memo_title.gsub(/^[[:space:]]+/, '').empty?
    puts "空白文字のみのタイトルは禁止されています。"
  else
    #csvファイルへの保存処理
    memo = Memo.new(memo_title, memo_content)
    memo.save
    redirect "/memos/#{memo.uuid}"
  end
end

get '/memos/:uuid' do
  memo_hash = Memo.find(params[:uuid])
  erb :'memos/show', :locals => {:memo_hash => memo_hash}
end

get '/memos/:uuid/edit' do
  memo_hash = Memo.find(params[:uuid])
  erb :'memos/edit', :locals => {:memo_hash => memo_hash}
end

patch '/memos/:uuid' do
  memo_title = params[:memo_contents].lines[0]
  memo_content = params[:memo_contents].lines[1..-1].join
  if memo_title.gsub(/^[[:space:]]+/, '').empty?
    puts "空白文字のみのタイトルは禁止されています。"
  else
    memo_hash = {uuid: params[:uuid], title: memo_title, content: memo_content}
    Memo.update(memo_hash)
    redirect "/memos/#{params[:uuid]}"
  end
end
