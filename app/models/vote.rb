class Vote
  include Mongoid::Document
  include Mongoid::Timestamps

  validates :type, inclusion: { in: [:up, :down] }

  field :type

  belongs_to :comment
  belongs_to :user

end
