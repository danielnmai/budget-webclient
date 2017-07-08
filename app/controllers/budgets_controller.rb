class BudgetsController < ApplicationController
  before_action :authenticate_user!, except: [:landing, :index, :create]
  def landing
    
  end
  def index
    @location = params[:location]
    @income = params[:income]
    @budget = Unirest.get('http://localhost:3001/api/v1/users/1/budgets/1').body
    @category_percentages = @budget['category_percentages']
    @monthly_income = @income.to_i / 12
    render 'index'
    
  end
  def create
    @budget = Budget.new(Unirest.get("http://localhost:3001/api/v1/users/#{current_user.id}/budgets/1").body)

    @current_user = current_user

    render 'show'
  end

  def new
    
  end

  def edit
    
  end

  def show
    
  end

  def update
    
  end
end
