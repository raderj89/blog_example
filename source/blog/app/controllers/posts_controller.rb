before "/posts/new" do
  unless logged_in?
    flash[:danger] = "You must be logged in to create posts."
    redirect "/"
  end
end

before "/posts/:id/edit" do
  @post = Post.find_by_id(params[:id])
  unless logged_in? && @post.user_id == @current_user.id
    flash[:danger] = "You can't edit a post that doesn't belong to you."
    redirect back
  end
end

before "/posts/:id" do
  if request.request_method == "DELETE"
    @post = Post.find_by_id(params[:id])
    unless logged_in? && @post.user_id == @current_user.id
      flash[:danger] = "You can't delete a post that doesn't belong to you."
      redirect back
    end
  end
end

get '/' do
  @posts = Post.paginate(:page => params[:page])

  erb :"posts/index"
end

get '/posts/new' do
  erb :"posts/new"
end

get '/posts/godzillaed' do

  # Using the custom scope
  @posts = Post.godzillaed

  if request.xhr?
    return @posts.to_json
  end

end

get '/posts/:id/edit' do
  @post = Post.find_by_id(params[:id])

  if @post
    erb :"posts/edit"
  else
    flash[:warning] = "That post doesn't exist."
    redirect "/"
  end
end

get '/posts/:id' do
  # This will raise a RecordNotFoundError and cause Sinatra to freak out
  # @post = Post.find(params[:id])

  # This returns a record or nil, so we can check whether we have a post
  @post = Post.find_by_id(params[:id])

  if @post
    erb :"posts/show"
  else
    flash[:warning] = "That post doesn't exist."
    redirect "/"
  end

end

post '/posts' do

  # BAD
  # @user = User.find(session[:user_id])
  
  # @post = Post.create(title: params[:post][:title], body: params[:post][:body])

  # params[:tags].split(", ").each do |tag|
  #   @post.tags << Tag.create(name: tag)
  # end

  # erb :"posts/show"

  # BETTER
  # Build the association
  @post = current_user.posts.build(params[:post])

  # Ensure the record saves
  if @post.save
    params[:tags].split(", ").each do |param_tag|

  # Make sure we don't create tags with the same name using first_or_create

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

put '/posts/:id/edit' do
  
  @post = current_user.posts.find(params[:id])

  if @post.update_attributes(params[:post])
    params[:tags].split(", ").each do |param_tag|
      tag = Tag.where(name: param_tag).first_or_create
      @post.tags << tag unless @post.tags.include?(tag)
    end
    flash[:success] = "Post successfully edited."
    redirect "/posts/#{@post.id}"
  else
    flash[:success] = "There was a problem editing your post. Please try again."
    erb :"posts/edit"
  end
end

delete '/posts/:id' do
  if @post.destroy
    flash[:warning] = "Post obliterated."
    redirect "/"
  else
    flash[:danger] = "An error occurred while trying to delete this post. Please try again."
    redirect "/posts/#{@post.id}"
  end
end
