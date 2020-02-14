require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'

get '/' do
	erb :index
end 
post '/' do 
	@user_name = params[:user_name]
	@user_password = params[:user_password]

	erb :index
	
	if @user_name = "admin" && @user_password == "secret"
		@message2 = "Access granted!"
		erb :index 
	else
		@message1 = "Access denied!"
		erb :index
	end
end


get '/visit' do 
	erb :visits
end
post '/visit' do
	@user_name = params[:user_name]
	@phone = params[:phone]
	@barber = params[:value]
	@color = params[:color]

	hh = {
		:user_name => "Введите имя",
		:phone => "Введите номер телефона"
		}

	hh.each do |key, value|
		if params[key] == ''
			@error = hh[key]
			return erb :visits
		end
	end
	
	@title = 'Спасибо'
	@message = "Спасибо, #{@user_name}! Вас будет ожидать #{@barber} и будет у вас отличный #{@color} цвет"
	
	f = File.open './public/users.txt', 'a'
	f.write "User: #{@user_name}\tPhone: #{@phone}\tBarber: #{@barber}\n"
	f.close
	erb :message
		
end


get '/admin' do
	erb :admin
end
post '/admin' do
	@user = params[:user]
	@user_password = params[:user_password]
	if @user == "admin" && @user_password == "secret"
		send_file './public/users.txt'
	else 
		@message1 = "Access denied"
		erb :admin
	end
end


get '/barber' do
	erb :barber
end


get '/contacts' do
	erb :contacts
end
post '/contacts' do
	@email = params[:input1]
	@message_text = params[:message_text]

	h2 = {
		:input1 => "Введите адрес электронной почты",
		:message_text => "Введите сообщение"
		}

	h2.each do |key, value|
		if params[key] == ''
			@error = h2[key]
			return erb :contacts
		end
	end

	Pony.mail({
  	:to => 'example@example.com',# here need email to get 
  	:from => 'example@example.com',# here need email to send
  	:via => :smtp,
  	:subject => "Новое сообщение от пользователя #{@email}",
  	:body => "#{@message_text }",
  	:via_options => {
    :address              => 'smtp.gmail.com',
    :port                 => '587',
    :enable_starttls_auto => true,
    :user_name            => 'username',#username email to send
    :password             => 'password', #password email to send
    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
    :domain               => "127.0.0.1" # the HELO domain provided by the client to the server
  }
})

	contacts = File.open './public/contacts.txt', 'a'
	contacts.write "User: #{@email}\nMessage: #{@message_text}\n\n"
	contacts.close


	erb 'Спасибо за ваше обращение! Мы скоро свяжемся с вами!'

end 


get '/about' do
	erb :about
end
