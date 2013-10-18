class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  validates :abusive, inclusion: {in: [true, false]}

  field :title
  field :body
  field :abusive, default: false

  belongs_to :post
  belongs_to :user
  has_many :votes

  def self.not_abusive;  where(abusive: false) end

end
