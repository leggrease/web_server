# require_relative 'contact'
require_relative 'rolodex'
require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, "sqlite3:database.sqlite3")

# $rolodex = Rolodex.new

# $rolodex.add_contact(Contact.new("Johnny", "Bravo", "johnny@bitmaker.com", "IM SMOKIN")) 
# p $rolodex.contacts

class Contact
	include DataMapper::Resource

	property :id, Serial
	property :first_name, String
	property :last_name, String
	property :email, String
	property :note, String
end

DataMapper.finalize
DataMapper.auto_upgrade!

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

get "/contacts/:id" do
	@contact = $rolodex.find(params[:id].to_i)
	if @contact
		erb :show_contact
	else
		raise Sinatra::NotFound
	end
end

get "/contacts/:id/edit" do
	@contact = $rolodex.find(params[:id].to_i)
	if @contact
		erb :edit_contact
	else
		raise Sinatra::NotFound
	end
end

put "/contacts/:id" do
	@contact = $rolodex.find(params[:id].to_i)
	if @contact
	@contact.first_name = params[:first_name]
	@contact.last_name = params[:last_name]
	@contact.email = params[:email]
	@contact.note = params[:note]

	redirect to ("/contacts")
	else
		raise Sinatra::NotFound
	end
end	

delete "/contacts/:id" do
  @contact = $rolodex.find(params[:id].to_i)
  if @contact
    $rolodex.remove_contact(@contact)
    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end