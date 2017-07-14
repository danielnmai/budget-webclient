class BudgetsController < ApplicationController
  before_action :authenticate_user!, except: [:landing, :index]
  def landing; end
  def new; end
  def index
    @location = params[:location]
    @income = params[:income]
    session[:location] = params[:location]
    session[:income] = params[:income]
    @budget = Budget.new(Unirest.get("#{ENV['API_ROOT_URL']}/users/1/budgets/1").body)
    @monthly_income = @income.to_i / 12
    render 'index'
  end

  def access
    public_token = params['public_token']
    redirect_to "/banks/#{public_token}"
  end

  def link_bank
    public_token = params['public_token']
    puts "PUBLIC TOKEN: " + public_token
    client = Plaid::Client.new(env: :sandbox,
                              client_id: ENV['PLAID_CLIENT_ID'],
                              secret: ENV['PLAID_SECRET'],
                              public_key: ENV['PLAID_PUBLIC_KEY'])
    response = client.item.public_token.exchange(public_token)
    access_token = response['access_token']

    @auth_response = client.auth.get(access_token)
    # @trans_response = client.transactions.get(access_token, '2010-01-01', '2017-07-15', account_ids: ['mexMMwz6y8Svw3zQZye9Um5pDEdzeDSmNy9Ao', '90VjjwBRL8Ia5vn3JgNLca56AeDKPAUPyKwLv'])
    # @total_transactions = @trans_response['total_transactions']

    item_id = response['item_id']
    puts "ACCESS TOKEN: #{access_token}"
    puts "ITEM ID: #{item_id}"
    puts "auth_response: #{@auth_response.to_json}"
    render 'show.json.jbuilder'
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
    @current_user = current_user
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
