require_relative 'contact'
require_relative 'rolodex'
require 'sinatra'

$rolodex= Rolodex.new 

#routes
get '/' do 
	erb :index
end

get '/contacts' do 
	erb :contacts
end

get '/contacts/new' do 
	erb :new_contact
end

post '/contacts' do
	new_contact = Contact.new(params[:first_name], params[:last_name], params[:email], params[:note])
	$rolodex.add_contact(new_contact)
	redirect to ('/contacts')
end
