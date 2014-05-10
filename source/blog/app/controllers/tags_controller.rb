
get '/tags' do
  @tags = Tag.order('created_at DESC')

  erb :"tags/index"

end

get '/tags/:id' do
  @tag = Tag.find(params[:id])
  erb :"tags/show"
end
