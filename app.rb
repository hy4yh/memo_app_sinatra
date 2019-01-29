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

['/memos/:uuid', "/memos/:uuid/edit"].each do |path|
  before path do
    if request.env["REQUEST_METHOD"] == "GET"
      @memo_hash = Memo.find(params[:uuid])
    end
  end
end

['/memos', "/memos/:uuid"].each do |path|
  before path do
    request_method = request.env["REQUEST_METHOD"]
    if request_method == "PATCH" || request_method == "POST"
      @memo_title = params[:memo_contents].lines[0]
      memo_content = params[:memo_contents].lines[1..-1]
      @memo_content = memo_content.join unless memo_content.nil?
    end
  end
end

get /\/(memos)?/ do
  memo_hash = Memo.all
  erb :'memos/index', :locals => {:memo_hash => memo_hash}
end

get '/memos/new' do
  erb :'memos/new'
end

post '/memos' do
  if @memo_title.nil? || @memo_title.gsub(/^[[:space:]]+/, '').empty?
    @error_msg = "1行目はメモのタイトルです。必ず入力してください。"
    erb :'memos/new'
  else
    #csvファイルへの保存処理
    memo = Memo.new(@memo_title, @memo_content)
    memo.save
    redirect "/memos/#{memo.uuid}"
  end
end

get '/memos/:uuid' do
  erb :'memos/show', :locals => {:memo_hash => @memo_hash}
end

get '/memos/:uuid/edit' do
  erb :'memos/edit', :locals => {:memo_hash => @memo_hash}
end

patch '/memos/:uuid' do
  memo_hash = {uuid: params[:uuid], title: @memo_title, content: @memo_content}
  if memo_hash[:title].nil? || memo_hash[:title].gsub(/^[[:space:]]+/, '').empty?
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
