class User < ApplicationRecord
  has_many :accounts
  has_many :transaction_logs
end
