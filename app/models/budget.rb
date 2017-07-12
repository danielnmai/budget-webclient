class Budget < ApplicationRecord
  attr_accessor :id, :user_id, :name, :category_name, :category_percentages, :category_percentages, :categories, :category_percent
  def initialize(input_hash)
    @id = input_hash['id']
    @user_id = input_hash['user_id']
    @name = input_hash['name']
    @categories = input_hash['categories']
    @category_percentages = input_hash['category_percentages']
  end

  def self.find(id, user_id)

    budget_hash = Unirest.get("http://localhost:3001/api/v1/users/#{user_id}/budgets/#{id}").body
    Budget.new(budget_hash)
  end

  def self.all(user_id)
    budgets = []
    api_budgets = Unirest.get("http://localhost:3001/api/v1/users/#{current_user.id}/budgets").body
    api_budgets.each do |api_budget|
      budgets << Budget.new(api_budget)
    end
  end

  def self.create(user_id, budget_name, cat_names, cat_percent)
    api_budget = Unirest.post("http://localhost:3001/api/v1/users/#{user_id}/budgets",
      headers:{ 'Accept' => 'application/json' },
      parameters: {
        name: budget_name,
        user_id: user_id}
        ).body
    budget = Budget.new(api_budget)
    cat_names.each_with_index do |name, index|
     percent = cat_percent[index]
     Unirest.patch("http://localhost:3001/api/v1/users/#{user_id}/budgets/#{id}/categories/#{index + 1}",
       headers:{ 'Accept' => 'application/json' },
       parameters: {name: name, percent: percent}
         ).body
   end
  end

  def category_names
    names = []
    api_categories = Unirest.get("http://localhost:3001/api/v1/users/#{user_id}/budgets/#{id}/categories").body
    api_categories.each do |api_category|
      names << api_category['name']
    end
    names
  end

  def category_percent
    percent = []
    api_categories = Unirest.get("http://localhost:3001/api/v1/users/#{user_id}/budgets/#{id}/categories").body
    api_categories.each do |api_category|
      percent << api_category['percent']
    end
    percent
  end

  def categories
    categories = []
    api_categories = Unirest.get("http://localhost:3001/api/v1/users/#{user_id}/budgets/#{id}/categories").body
    api_categories.each do |api_category|
      categories << api_category
    end
    categories
  end

  def update(budget_name, cat_names, cat_percent)
    Unirest.patch("http://localhost:3001/api/v1/users/#{user_id}/budgets/#{id}/",
      headers:{ 'Accept' => 'application/json' },
      parameters: {name: budget_name}  
        ).body
    cat_names.each_with_index do |name, index|
      percent = cat_percent[index]
      Unirest.patch("http://localhost:3001/api/v1/users/#{user_id}/budgets/#{id}/categories/#{index + 1}",
        headers:{ 'Accept' => 'application/json' },
        parameters: {name: name, percent: percent}
          ).body
    end
  end
end
