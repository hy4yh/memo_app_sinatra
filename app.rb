require 'sinatra'
require 'sinatra/reloader'
require_relative './models/memo.rb'
require 'cgi/escape'
require 'byebug'

helpers do
  def escape_html(str)
    CGI.escapeHTML(str)
  end

  def n_to_br(str)
    str.gsub(/\r\n|\r|\n/, "<br/>")
  end
end

before '/*' do
  @error_msg = ""
end

get /\/(memos)?/ do
  memo_hash = Memo.all
  erb :'memos/index', :locals => {:memo_hash => memo_hash}
end

get '/memos/new' do
  erb :'memos/new'
end

post '/memos' do
  memo_title = params[:memo_contents].lines[0]
  memo_content = params[:memo_contents].lines[1..-1]
  memo_content = memo_content.join unless memo_content.nil?
  if memo_title.nil? || memo_title.gsub(/^[[:space:]]+/, '').empty?
    @error_msg = "1行目はメモのタイトルです。必ず入力してください。"
    erb :'memos/new'
  else
    #csvファイルへの保存処理
    memo = Memo.new(memo_title, memo_content)
    memo.save
    redirect "/memos/#{memo.uuid}"
  end
end

get '/memos/:uuid' do
  @memo_hash = Memo.find(params[:uuid])
  erb :'memos/show', :locals => {:memo_hash => @memo_hash}
end

get '/memos/:uuid/edit' do
  @memo_hash = Memo.find(params[:uuid])
  erb :'memos/edit', :locals => {:memo_hash => @memo_hash}
end

patch '/memos/:uuid' do
  memo_title = params[:memo_contents].lines[0].encode(universal_newline: true)
  memo_content = params[:memo_contents].lines[1..-1]
  memo_content = memo_content.join.encode(universal_newline: true) unless memo_content.nil?
  memo_hash = {uuid: params[:uuid], title: memo_title, content: memo_content}
  if memo_title.nil? || memo_title.gsub(/^[[:space:]]+/, '').empty?
    @error_msg = "1行目はメモのタイトルです。必ず入力してください。"
    erb :"memos/edit", :locals => {:memo_hash => memo_hash}
  else
    Memo.update(memo_hash)
    redirect "/memos/#{params[:uuid]}"
  end
end

delete '/memos/:uuid' do
  Memo.delete(params[:uuid])
  redirect "/memos"
end
