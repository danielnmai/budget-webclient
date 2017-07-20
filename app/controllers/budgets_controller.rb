class BudgetsController < ApplicationController
  before_action :authenticate_user!, except: [:default, :landing]
  def landing
    render :layout => 'landing.html.erb'
  end
  def new; end
  def default
    @location = params[:location]
    @income = params[:income].delete(',')
    session[:location] = params[:location]
    session[:income] = params[:income]
    @budget = Budget.new(Unirest.get("#{ENV['API_ROOT_URL']}/users/1/budgets/1").body)
    cat_names = @budget.category_names
    cat_percent = @budget.calculate_budget(@location, @income)
    @budget.update('default_name', cat_names, cat_percent)
    @monthly_income = @income.to_i / 12
    render 'default'
  end

  def index
    @budgets = Budget.all(current_user.id)
    @monthly_income = 6500
  end

  def access
    public_token = params['public_token']
    redirect_to "/users/#{current_user.id}/bank/#{public_token}"
  end

  def link_bank
    @budget = Budget.find(1, current_user.id)
    public_token = params['public_token']
    client = Plaid::Client.new(
      # env: :sandbox,
      env: :development,
                              client_id: ENV['PLAID_CLIENT_ID'],
                              secret: ENV['PLAID_SECRET'],
                              public_key: ENV['PLAID_PUBLIC_KEY'])
    response = client.item.public_token.exchange(public_token)
    access_token = response['access_token']

    now = Date.today
    thirty_days_ago = (now - 30)
    trans_response = client.transactions.get(access_token, thirty_days_ago, now)

    @transactions = trans_response['transactions']

    trans_ary = []
    amounts = []
    cat_amount = {}
    @cat_sum = {}

    @transactions.each do |transaction|
      trans_ary << transaction['category']
      @cat_sum[transaction['category']] = 0
      amounts << transaction['amount']
      cat_amount[transaction['category']] = transaction['amount']
    end

    @cat_total = amounts.sum
    @cat_sum[['Other']] = 0
    @transactions.each do |transaction|
      cat = transaction['category']
      if @cat_sum.has_key?(cat)
        @cat_sum[cat] += transaction['amount']
        if cat.nil?
          @cat_sum[['Other']] += transaction['amount']   
        end
      end
    end
    
    @cat_sum = Hash[@cat_sum.sort_by{|k, v| v}.reverse]

    @cat_sum.each do |cat|
      cat.compact!     
    end
    @cat_sum_keys = @cat_sum.keys

    p @cat_sum

    category_ary = trans_ary.flatten
    category_ary.each do |cat|
      if cat.nil?
        category_ary << 'Other'
      end
    end

    category_ary = category_ary.compact

    @category_hash = {}

    category_ary.each do |cat|
      count = category_ary.count(cat)
      @category_hash[cat] = count
    end

    @sorted_cat_hash = @category_hash.sort_by {|_key, value| value}.reverse
    render 'transaction_show.html.erb'
  end

  def create
    if params[:default_chosen]
      default_budget = Budget.find(1, 1)
      @budget = Budget.create(current_user.id, params[:name],default_budget.category_names, default_budget.category_percent)
    else
      cat_amount = params[:cat_amount]
      income = params[:monthly_income].to_i
      cat_percent = []
      cat_amount.each do |amount|
        cat_percent << ((amount.to_f / income) * 100).to_i
      end
      p params[:cat_amount]
      p cat_percent
      @budget = Budget.create(current_user.id, params[:name],params[:cat_names], cat_percent)
    end

    if @budget.user_id == current_user.id
      flash[:success] = 'Successfully created budget!'
      redirect_to "/budgets/#{@budget.id}"
    else 
      flash[:warning] = 'Cannot create this budget!'
      redirect_to '/budgets'
    end
  end

  def edit
    api_budget = Unirest.get("#{ENV['API_ROOT_URL']}/users/#{current_user.id}/budgets/#{params[:id]}").body
    @budget = Budget.new(api_budget)
  end

  def show
    @budget = Budget.find(params[:id], current_user.id)
  end

  def update
    @budget = Budget.find(params[:id], current_user.id)
    @budget.update(params[:name], params[:category_names], params[:category_percent])
    @name = @budget.name
    @category_names = params[:category_names]
    @category_percent = params[:category_percent]
    redirect_to "/budgets/#{params[:id]}"
  end

  def destroy
    Unirest.delete("#{ENV['API_ROOT_URL']}/users/#{current_user.id}/budgets/#{params[:id]}", headers:{'Accept' => 'Application/json'} )
    flash[:warning] = 'Budget successfully deleted'
    redirect_to '/budgets'
  end
end
