class Vote
  include Mongoid::Document
  include Mongoid::Timestamps

  validates :value, inclusion: { in: [-1, 1] }

  field :value, type: Integer

  belongs_to :comment
  belongs_to :user

  after_create do
    if value == -1 && comment.votes.where(value: -1).count >= 3
      comment.update_attributes(abusive: true)
    end
  end

end
