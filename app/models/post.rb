class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable

  field :body, type: String
  field :title, type: String
  field :archived, type: Boolean, default: false

  validates_presence_of :body, :title

  has_many :comments, dependent: :destroy
  belongs_to :user

  default_scope ne(archived: true)

  def archive!
    update_attribute :archived, true
  end

  def self.tag_cloud
    tags = []
    each {|post| tags<<post.tags_array}
    tag_cloud = {}
    tags.flatten!
    if tags
      tags.each {|tag| tag_cloud.key?(tag) ? tag_cloud[tag]+=1 : tag_cloud[tag]=1.0 }
      tag_cloud.sort
    end
  end

  def hotness
    inc = comments.count >= 3 ? 1 : 0
    if    created_at >= Time.zone.now - 24.hours
      3 + inc
    elsif created_at >= Time.zone.now - 72.hours
      2 + inc
    elsif created_at >= Time.zone.now - 7.days
      1 + inc
    else
      0 + inc
    end      
  end


end
