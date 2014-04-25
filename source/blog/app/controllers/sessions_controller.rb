require 'pry-rails'
get '/login' do
  if logged_in?
    redirect "/users/#{@current_user.id}"
  else
    erb :"sessions/new"
  end
end

post '/login' do
  user = User.authenticate(params[:email], params[:password])

  if user
    session[:user_id] = user.id
    redirect "/users/#{user.id}"
  else
    redirect "/"
  end
end

get '/logout' do
  session.clear
  redirect "/"
end
