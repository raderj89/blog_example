before '/users/sign*' do
  if logged_in?
    flash[:warning] = "You are already signed in."
    redirect "/users/#{@current_user.id}"
  end
end

get '/users/sign_up' do
  erb :"users/register"
end

post '/users/sign_up' do
  # if logged_in?
  #   redirect "/users/#{@current_user.id}"
  # else
  @user = User.new(params[:user])
  if @user.save
    session[:user_id] = @user.id
    redirect "/users/#{@user.id}"
  else
    erb :"users/register"
  end
end



get '/users/:id' do
  # if logged_in?
  @user = User.find_by_id(params[:id])
  if @user
    @posts = @user.posts.order('created_at DESC')
    erb :"users/show"
  else
    redirect :"sessions/new"
  end
  # else
  #   erb :"sessions/new"
  # end
end

# before '/users/:id' do
#   unless logged_in?
#     flash[:warning] = "You must be signed in to view that page."
#     redirect back
#   end
# end