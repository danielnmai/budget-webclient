class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id

      flash[:success] = 'Successfully logged in!'
      redirect_to budgets_path(income: session[:income], location: session[:location])
    else
      flash[:warning] = 'Invalid email or password!'
      redirect_to budgets_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'Successfully logged out!'
    redirect_to '/'
  end
end
