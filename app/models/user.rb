class User < ApplicationRecord
  has_many :accounts
  has_many :activity_logs
end
