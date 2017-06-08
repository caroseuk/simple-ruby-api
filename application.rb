require 'sinatra'
require 'sinatra/json'
require 'bundler'
Bundler.require

#If you prefer to use SQLite, then comment this line out and uncomment the line below.
DataMapper.setup(:default, 'mysql://root:root@localhost/rubyapi')

# Define Review Model
class Review
 include DataMapper::Resource

 property :id, Serial
 property :name, String
 property :text, String
 property :created_at, DateTime
 property :updated_at, DateTime

 validates_presence_of :name
 validates_presence_of :text
end

#Uncomment if you would like to use sqlite as storage
#DataMapper.setup(:default, 'sqlite::memory')
DataMapper.finalize
DataMapper.auto_upgrade!

# Authentication - before executing any routes, check the value of the 'key' paramter to make sure it is authorised to query the API.
before do
  error 401 unless params[:key] =~ /^123456789/
end

# Begin API route definitions
get '/' do
"Provide a verb to query the API"
end

get '/reviews' do
 content_type :json

 reviews = Review.all
 reviews.to_json
end

get '/reviews/:id' do
	content_type :json
	review = Review.get params[:id]
	review.to_json
end

put '/reviews/:id' do
	content_type :json
	review = Review.get params[:id]
	if review.update params[:review]
		status 200
		json "Record was updated!"
	else
		status 500
		json review.errors.full_messages
	end
end

post '/reviews' do
	 content_type :json
	 review = Review.new params[:review]
	 if review.save
		  status 201
		  json "Record created!"
	 else
		  staus 500
		  json review.errors.full_messages
	 end
end

delete '/reviews/:id' do
	content_type :json
	review = Review.get params[:id]
	if review.destroy
		status 200
		json "Review Deleted Successfully!"
	else
		status 500
		json "There was a problem deleting the review"
	end

end
