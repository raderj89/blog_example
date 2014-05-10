require 'faker'

tags = ["godzilla", "mothra", "king ghidorah", "muto"]

20.times do
  user = User.create(name: Faker::Name.name,
                     email: Faker::Internet.email,
                     password: "password")
  post = user.posts.create(title: Faker::Lorem.sentence, body: Faker::Lorem.paragraph(5))
  3.times do
    tag = Tag.where(name: tags.sample).first_or_create
    post.tags << tag unless post.tags.include?(tag)
  end
end
