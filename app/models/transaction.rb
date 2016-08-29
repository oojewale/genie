class Transaction < ApplicationRecord
  has_many :transaction_logs
end
