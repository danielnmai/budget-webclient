class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(params[:email])
    puts "USER INFORMATION"
    puts "PASSWORD_Digest"
    puts user.password_digest
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = 'Successfully logged in!'
      redirect_to '/'
    else
      flash[:warning] = 'Invalid email or password!'
      redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'Successfully logged out!'
    redirect_to '/login'
  end
end
