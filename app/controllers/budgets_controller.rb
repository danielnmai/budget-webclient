class BudgetsController < ApplicationController
  before_action :authenticate_user!, except: [:default, :landing]
  def landing
    render :layout => 'landing.html.erb'
  end
  def new; end
  def default
    @location = params[:location]
    @income = params[:income].delete(',')
    puts "INCOME: " + @income
    session[:location] = params[:location]
    session[:income] = params[:income]
    @budget = Budget.new(Unirest.get("#{ENV['API_ROOT_URL']}/users/1/budgets/1").body)
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
    render 'transaction_show.html.erb'
  end

  def create
    if params[:default_chosen]
      default_budget = Budget.find(1, 1)
      @budget = Budget.create(current_user.id, params[:name],default_budget.category_names, default_budget.category_percent)
    else
      @budget = Budget.create(current_user.id, params[:name],params[:cat_names], params[:cat_percent])
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
