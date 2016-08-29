class Account < ApplicationRecord
  belongs_to :user
  has_one :atm
end
