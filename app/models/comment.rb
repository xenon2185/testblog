class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :body

  belongs_to :post
  belongs_to :user
  has_many :votes

end
