require "pry-rails"

before "/*" do
  current_user
end

before "/posts/new" do
  unless logged_in?
    flash[:danger] = "You must be logged in to create posts."
    redirect "/"
  end
end

before "/posts/edit/:id" do
  @post = Post.find(params[:id])
  unless logged_in? && @post.user_id == @current_user.id
    flash[:danger] = "You can't edit a post that doesn't belong to you."
    redirect back
  end
end

before "/posts/:id" do
  if request.request_method == "DELETE"
    @post = Post.find(params[:id])
    unless logged_in? && @post.user_id == @current_user.id
      flash[:danger] = "You can't delete a post that doesn't belong to you."
      redirect back
    end
  end
end

get '/' do
  @posts = Post.order('created_at DESC')

  erb :"posts/index"
end

get '/posts/new' do
  erb :"posts/new"
end

get '/posts/edit/:id' do
  @post = Post.find(params[:id])
  erb :"posts/edit"
end

get '/posts/:id' do
  # current_user
  @post = Post.find(params[:id])

  erb :"posts/show"
end

post '/posts' do
  # current_user # Why do I need to call this method? @current_user is nil if I don't
  @post = @current_user.posts.build(params[:post])
  if @post.save
    params[:tags].split(", ").each do |param_tag|
      tag = Tag.where(name: param_tag).first_or_create
      @post.tags << tag
    end
    flash[:success] = "Post successfully created!"
    redirect "/posts/#{@post.id}"
  else
    flash[:danger] = "There was a problem creating your post. Please try again."
    erb :"posts/new"
  end
end

put '/posts/:id' do
  current_user
  @post = @current_user.posts.find(params[:id])

  if @post.update_attributes(params[:post])
    params[:tags].split(", ").each do |param_tag|
      tag = Tag.where(name: param_tag).first_or_create
      @post.tags << tag
    end
    flash[:success] = "Post successfully edited."
    redirect "/posts/#{@post.id}"
  else
    flash[:success] = "There was a problem editing your post. Please try again."
    erb :"posts/edit"
  end
end

delete '/posts/:id' do
  @post = Post.find(params[:id])

  if @post.destroy
    flash[:warning] = "Post obliterated."
    redirect "/"
  else
    flash[:danger] = "An error occurred while trying to delete this post. Please try again."
    redirect "/posts/#{@post.id}"
  end
end
