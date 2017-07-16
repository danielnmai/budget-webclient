class Transaction < ApplicationRecord
  attr_accessor :date, :description, :category, :amount

  def initialize(input_hash)
    @date = input_hash["date"]
    @description = input_hash["name"]
    @category = input_hash["category"]
    @amount = input_hash["amount"]
  end

  def self.all(transactions)
    transactions = []
    transactions.each do |transaction|
      transactions << Transaction.new(transaction)
    end
    transactions
  end
end