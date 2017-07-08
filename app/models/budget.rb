class Budget < ApplicationRecord
  attr_accessor :id, :user_id, :name, :categories, :category_percentages
  def initialize(input_hash)
    @id = input_hash['id']
    @user_id = input_hash['user_id']
    @name = input_hash['name']
    @categories = input_hash['categories']
    @category_percentages = input_hash['category_percentages']
  end

  def self.find(id)
    budget_hash = Unirest.get("http://localhost:3001/api/v1/users/#{current_user.id}/budgets/#{id}").body
    Budget.new(budget_hash)
  end

  def self.all
    budgets = []
    api_budgets = Unirest.get("http://localhost:3001/api/v1/users/#{current_user.id}/budgets").body
    api_budgets.each do |api_budget|
      budgets << Budget.new(api_budget)
    end
  end
end
