#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
    @db = SQLite3::Database.new 'leprosorium.db'
    @db.results_as_hash = true
end

before do #прикаждом вызове
  init_db
end

configure do #при инициализации и при обновлении страницы
	init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts 
	(
    			id           INTEGER PRIMARY KEY AUTOINCREMENT,
    			Created_date DATE,
    			content      TEXT
	)'

end

get '/' do
	@results = @db.execute 'SELECT * FROM Posts ORDER BY id DESC'
	erb :index			
end

get '/new' do
  erb :new
end

post '/new' do
    content = params[:content]
    if content.length <= 0
    	@error = 'Type post text'
    	return erb :new
    end

    @db.execute 'insert into Posts (content, Created_date) values (?, datetime())', [content]
    redirect to '/'
end