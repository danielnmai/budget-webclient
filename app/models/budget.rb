class Budget < ApplicationRecord
  attr_accessor :id, :user_id, :name, :category_name, :category_percentages, :categories, :monthly_income
  def initialize(input_hash)
    @id = input_hash['id']
    @user_id = input_hash['user_id']
    @name = input_hash['name']
    @categories = input_hash['categories']
    @category_percentages = input_hash['category_percentages']
    @monthly_income = input_hash['monthly_income']
  end

  def self.find(id, user_id)
    budget_hash = Unirest.get("#{ENV['API_ROOT_URL']}/users/#{user_id}/budgets/#{id}").body
    Budget.new(budget_hash)
  end

  def self.all(user_id)
    budgets = []
    api_budgets = Unirest.get("#{ENV['API_ROOT_URL']}/users/#{user_id}/budgets").body
    api_budgets.each do |api_budget|
      budgets << Budget.new(api_budget)
    end
    budgets
  end

  def self.create(user_id, budget_name, cat_names, cat_percent)
    api_budget = Unirest.post("#{ENV['API_ROOT_URL']}/users/#{user_id}/budgets",
      headers:{ 'Accept' => 'application/json' },
      parameters: {
        name: budget_name,
        user_id: user_id}
        ).body
    budget = Budget.new(api_budget)

    cat_names.each_with_index do |name, index|
    percent = cat_percent[index]
     Unirest.post("#{ENV['API_ROOT_URL']}/users/#{user_id}/budgets/#{budget.id}/categories",
       headers:{ 'Accept' => 'application/json' },
       parameters: { category_name: name, category_percent: percent }
      ).body
    end
    budget
  end

  def category_names
    names = []
    api_categories = Unirest.get("#{ENV['API_ROOT_URL']}/users/#{user_id}/budgets/#{id}/categories").body
    api_categories.each do |api_category|
      names << api_category['name']
    end
    names
  end

  def category_percent
    percent = []
    api_categories = Unirest.get("#{ENV['API_ROOT_URL']}/users/#{user_id}/budgets/#{id}/categories").body
    api_categories.each do |api_category|
      percent << api_category['percent']
    end
    percent
  end

  def categories
    categories = []
    api_categories = Unirest.get("#{ENV['API_ROOT_URL']}/users/#{user_id}/budgets/#{id}/categories").body
    api_categories.each do |api_category|
      categories << api_category
    end
    categories
  end

  def update(budget_name, cat_names, cat_percent)
    hash_budget = Unirest.patch("#{ENV['API_ROOT_URL']}/users/#{user_id}/budgets/#{id}/",
      headers:{ 'Accept' => 'application/json' },
      parameters: {name: budget_name} 
        ).body
    budget = Budget.new(hash_budget)
    cat_index = budget.categories.first['id']

    cat_names.each_with_index do |name, index|
      percent = cat_percent[index]
      Unirest.patch("#{ENV['API_ROOT_URL']}/users/#{user_id}/budgets/#{id}/categories/#{cat_index}",
        headers:{ 'Accept' => 'application/json' },
        parameters: {name: name, percent: percent}
          ).body
      cat_index += 1
    end
  end

  def calculate_budget(location, income)

    location = location.split(", ")[1]
    region_states = Hash[*File.read('states_and_regions.txt').split(/[, \n]+/)]

    # Alaska  AK  West  Pacific
    # Alabama AL  South East South Central
    # Arkansas  AR  South West South Central
    # Arizona AZ  West  Mountain
    # California  CA  West  Pacific
    # Colorado  CO  West  Mountain
    # Connecticut CT  Northeast New England
    # District of Columbia  DC  South South Atlantic
    # Delaware  DE  South South Atlantic
    # Florida FL  South South Atlantic
    # Georgia GA  South South Atlantic
    # Hawaii  HI  West  Pacific
    # Iowa  IA  Midwest West North Central
    # Idaho ID  West  Mountain
    # Illinois  IL  Midwest East North Central
    # Indiana IN  Midwest East North Central
    # Kansas  KS  Midwest West North Central
    # Kentucky  KY  South East South Central
    # Louisiana LA  South West South Central
    # Massachusetts MA  Northeast New England
    # Maryland  MD  South South Atlantic
    # Maine ME  Northeast New England
    # Michigan  MI  Midwest East North Central
    # Minnesota MN  Midwest West North Central
    # Missouri  MO  Midwest West North Central
    # Mississippi MS  South East South Central
    # Montana MT  West  Mountain
    # North Carolina  NC  South South Atlantic
    # North Dakota  ND  Midwest West North Central
    # Nebraska  NE  Midwest West North Central
    # New Hampshire NH  Northeast New England
    # New Jersey  NJ  Northeast Middle Atlantic
    # New Mexico  NM  West  Mountain
    # Nevada  NV  West  Mountain
    # New York  NY  Northeast Middle Atlantic
    # Ohio  OH  Midwest East North Central
    # Oklahoma  OK  South West South Central
    # Oregon  OR  West  Pacific
    # Pennsylvania  PA  Northeast Middle Atlantic
    # Rhode Island  RI  Northeast New England
    # South Carolina  SC  South South Atlantic
    # South Dakota  SD  Midwest West North Central
    # Tennessee TN  South East South Central
    # Texas TX  South West South Central
    # Utah  UT  West  Mountain
    # Virginia  VA  South South Atlantic
    # Vermont VT  Northeast New England
    # Washington  WA  West  Pacific
    # Wisconsin WI  Midwest East North Central
    # West Virginia WV  South South Atlantic
    # Wyoming WY  West

    
  end
end
