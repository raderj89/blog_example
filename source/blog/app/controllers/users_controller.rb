

get '/users/sign_up' do
  erb :"users/register"
end

post '/users/sign_up' do
  if logged_in?
    redirect "/users/#{@current_user.id}"
  else
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect "/users/#{@user.id}"
    else
      erb :"users/register"
    end
  end
end

get '/users/:id' do
  if logged_in?
    @user = User.find(params[:id])
    if @user
      @posts = @user.posts.order('created_at DESC')
      erb :"users/show"
    else
      redirect "/"
    end
  else
    erb :"sessions/new"
  end
end
