class Conversation < ApplicationRecord
  belongs_to :user, foreign_key: :sender_id
  belongs_to :user, foreign_key: :recipient_id
  has_many :messages, dependent: :destroy
  validates :sender_id, uniqueness: {scope: :recipient_id}

  def self.between(sender_id,recipient_id)
    Conversation.where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND conversations.recipient_id =?)", sender_id,recipient_id, recipient_id, sender_id)

  end

end


# Conversation.where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND conversations.recipient_id =?)", sender_id,recipient_id, recipient_id, sender_id)
