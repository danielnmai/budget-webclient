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
    income = income.to_i
    region_states = Hash[*File.read('app/models/states_and_regions.txt').split(/, |\n/)]
    ary = []

    if region_states[location] == 'Northeast'
      puts "#{location} belong to region 1"
      if income > 70000
        average_spending = 93092.0
        food_spending = 10187
        housing_spending = 30225
        transportation_spending = 14655
        medical_spending = 6388
        tax_spending = 28263
        other_spending = 3308 #Entertainment

        ary = calculate_percent(average_spending, food_spending, housing_spending, medical_spending, transportation_spending, tax_spending, other_spending)
        p ary
        p ary.sum.ceil

      elsif income > 50000 && income < 69999
        average_spending = 53285.0
        food_spending = 6152
        housing_spending = 19464
        transportation_spending = 9223
        medical_spending = 4617
        tax_spending = 5020
        other_spending = 2606 #Entertainment

        ary = calculate_percent(average_spending, food_spending, housing_spending, medical_spending, transportation_spending, tax_spending, other_spending)
        p ary
        p ary.sum.ceil
      else
        average_spending = 43239.0
        food_spending = 5208
        housing_spending = 16986
        transportation_spending = 6997
        medical_spending = 4102
        tax_spending = 2187
        other_spending = 1986 #Entertainment

        ary = calculate_percent(average_spending, food_spending, housing_spending, medical_spending, transportation_spending, tax_spending, other_spending)
        p ary
        p ary.sum.ceil
      end
    elsif region_states[location] == 'Midwest'
      puts "#{location} belong to region 2"
      if income > 70000
        average_spending = 87054.0
        food_spending = 10513
        housing_spending = 25492
        transportation_spending = 14376
        medical_spending = 6584
        tax_spending = 23404
        other_spending = 4909 #Entertainment

        ary = calculate_percent(average_spending, food_spending, housing_spending, medical_spending, transportation_spending, tax_spending, other_spending)
        p ary
        p ary.sum.ceil
      
      elsif income > 50000 && income < 69999
        average_spending = 49651.0
        food_spending = 6668
        housing_spending = 15798
        transportation_spending = 9344
        medical_spending = 4644
        tax_spending = 5140
        other_spending = 2544 #Entertainment

        ary = calculate_percent(average_spending, food_spending, housing_spending, medical_spending, transportation_spending, tax_spending, other_spending)
        p ary
        p ary.sum.ceil
        
      else
        average_spending = 42370.0
        food_spending = 5492
        housing_spending = 13674
        transportation_spending = 8302
        medical_spending = 4165
        tax_spending = 1875
        other_spending = 2175 #Entertainment

        ary = calculate_percent(average_spending, food_spending, housing_spending, medical_spending, transportation_spending, tax_spending, other_spending)
        p ary
        p ary.sum.ceil
        
      end
    elsif region_states[location] == 'South'
      puts "#{location} belong to region 3"
      if income > 70000
        average_spending = 87168.0
        food_spending = 10102
        housing_spending = 15707
        transportation_spending = 14238
        medical_spending = 6447
        tax_spending = 21244
        other_spending = 4654 #Entertainment

        ary = calculate_percent(average_spending, food_spending, housing_spending, medical_spending, transportation_spending, tax_spending, other_spending)
        p ary
        p ary.sum.ceil
        
      elsif income > 50000 && income < 69999
        average_spending = 49662.0
        food_spending = 6400
        housing_spending = 15708
        transportation_spending = 10132
        medical_spending = 4458
        tax_spending = 4176
        other_spending = 2264 #Entertainment

        ary = calculate_percent(average_spending, food_spending, housing_spending, medical_spending, transportation_spending, tax_spending, other_spending)
        p ary
        p ary.sum.ceil
        
      else
        average_spending = 42791.0
        food_spending = 5670
        housing_spending = 14513
        transportation_spending = 8763
        medical_spending = 3608
        tax_spending = 1798
        other_spending = 2040 #Entertainment

        ary = calculate_percent(average_spending, food_spending, housing_spending, medical_spending, transportation_spending, tax_spending, other_spending)
        p ary
        p ary.sum.ceil
        
      end
    elsif region_states[location] == 'West'
      puts "#{location} belong to region 4"

      if income > 70000
        average_spending = 91948.0
        food_spending = 10912
        housing_spending = 29173
        transportation_spending = 14238
        medical_spending = 6159
        tax_spending = 24063
        other_spending = 5066

        ary = calculate_percent(average_spending, food_spending, housing_spending, medical_spending, transportation_spending, tax_spending, other_spending)
        p ary
        p ary.sum.ceil
        
      elsif income > 50000 && income < 69999
        average_spending = 53994.0
        food_spending = 6856
        housing_spending = 18802
        transportation_spending = 9613
        medical_spending = 4650
        tax_spending = 4074
        other_spending = 2712 #Entertainment

        ary = calculate_percent(average_spending, food_spending, housing_spending, medical_spending, transportation_spending, tax_spending, other_spending)
        p ary
        p ary.sum.ceil
        
      else
        average_spending = 44796.0
        food_spending = 5797
        housing_spending = 16481
        transportation_spending = 8208
        medical_spending = 3308
        tax_spending = 1837
        other_spending = 2259 #Entertainment

        ary = calculate_percent(average_spending, food_spending, housing_spending, medical_spending, transportation_spending, tax_spending, other_spending)
        p ary
        p ary.sum.ceil
        
      end
    end
    ary
  end
  def calculate_percent(average_spending, food, housing, medical, transportation, tax, other)
    saving = average_spending - (food + housing + transportation + medical + tax + other)
    puts "SAVING: #{saving}"
    food_percent = (food / average_spending).round(2) * 100
    housing_percent = (housing / average_spending).round(2) * 100
    medical_percent = (medical / average_spending).round(2) * 100
    transportation_percent = (transportation / average_spending).round(2) * 100
    tax_percent = (tax / average_spending).round(2) * 100
    other_percent = (other / average_spending).round(2) * 100
    saving_percent = (saving / average_spending).round(2) * 100

    percent_ary = [food_percent.round, housing_percent.round, medical_percent.round, transportation_percent.round, tax_percent.round, other_percent.round, saving_percent.round]
  end
end
