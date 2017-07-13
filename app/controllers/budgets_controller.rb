class BudgetsController < ApplicationController
  before_action :authenticate_user!, except: [:landing, :index]
  def landing; end
  def new; end
  def index
    @location = params[:location]
    @income = params[:income]
    session[:location] = params[:location]
    session[:income] = params[:income]
    @budget = Budget.new(Unirest.get('http://localhost:3001/api/v1/users/1/budgets/1').body)
    @monthly_income = @income.to_i / 12
    render 'index'
  end

  def create_default
    @budget = Budget.find(1, 1)
    render 'show'
  end

  def create
    @budget = Budget.create(current_user.id, params[:name], params[:cat_names], params[:cat_percent])
    p params[:cat_names]
    p params[:cat_percent]

    if @budget.user_id == current_user.id
      flash[:success] = 'Successfully created budget!'
      redirect_to "/budgets/#{@budget.id}"
    else 
      flash[:warning] = 'Cannot create this budget!'
      redirect_to '/budgets'
    end
  end

  def edit
    api_budget = Unirest.get("http://localhost:3001/api/v1/users/#{current_user.id}/budgets/#{params[:id]}").body
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
    Unirest.delete("http://localhost:3001/api/v1/users/#{current_user.id}/budgets/#{params[:id]}", headers:{'Accept' => 'Application/json'} )
    flash[:warning] = 'Budget successfully deleted'
    redirect_to '/budgets'
  end
end
