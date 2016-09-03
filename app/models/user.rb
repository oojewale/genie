class User < ApplicationRecord
  has_many :accounts
  has_many :activity_logs
  has_many :conversation_contexts
  has_many :otps

  def fullname
    "#{firstname} #{lastname}"
  end

  def get_statement
    state = accounts.pluck(:account_num, :account_type, :balance).map do |acc|
      "Account number: #{acc[0]}\nAccount type: #{acc[1]}\nAccount balance: #{acc[2]}\n"
    end

    state.join("\n")
  end
end
