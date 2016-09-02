class User < ApplicationRecord
  has_many :accounts
  has_many :activity_logs
  has_many :conversation_contexts
  has_many :otps

  def fullname
    "#{firstname} #{lastname}"
  end
end
