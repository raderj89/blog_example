class Post < ActiveRecord::Base
  validates :body, presence: true
  validates :title, presence: true

  has_and_belongs_to_many :tags
  belongs_to :user

  # Default scope, without eager loading
  default_scope { order('created_at DESC') }

  # Default scope, with eager loading
  #default_scope { includes(:tags).order('created_at DESC') }

  # Custom Scope
  scope :godzillaed, -> { joins(:tags).where(tags: { name: 'godzilla' } ) }

  self.per_page = 10

  def show_tags
    tag_string = ""
    # pluck(:name) allows me to return just the name attributes in all my tag records
    tags.pluck(:name).each do |tag| 
      tag_string << "#{tag}, "
    end
    tag_string
  end


end
