get '/login' do
  if logged_in?
    flash[:warning] = "You are already logged in."
    redirect "/users/#{@current_user.id}"
  else
    erb :"sessions/new"
  end
end

post '/login' do
  user = User.find_by_email(params[:email])

  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect "/users/#{user.id}"
  else
    flash[:danger] = "Your username or password is incorrect."
    redirect back
  end
end

get '/logout' do
  session.clear
  redirect "/"
end
