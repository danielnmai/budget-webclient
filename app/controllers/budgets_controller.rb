class BudgetsController < ApplicationController
  before_action :authenticate_user!, except: [:landing, :index]
  def landing

  end
  def index
    @location = params[:location]
    @income = params[:income]
    session[:location] = params[:location]
    session[:income] = params[:income]
    @budget = Unirest.get('http://localhost:3001/api/v1/users/1/budgets/1').body
    @categories = Unirest.get('http://localhost:3001/api/v1/users/1/budgets/1/categories').body
    @monthly_income = @income.to_i / 12
    render 'index'
  end

  def create
    @budget = Budget.create(current_user.id, params[:name], params[:category_name], params[:category_percent])
    puts "NEW BUDGET: " + @budget.name
    if @budget.user_id == current_user.id
      flash[:success] = 'Successfully created budget!'
      redirect_to "/budgets/#{@budget.id}"
    else 
      flash[:warning] = 'Cannot create this budget!'
      redirect_to '/budgets'
    end
  end

  def new

  end

  def edit

  end

  def show
    @budget = Budget.find(params[:id], current_user.id)
  end

  def update

  end
end
