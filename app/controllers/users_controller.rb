class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new; end

  def create
    new_user = Unirest.post("http://localhost:3001/api/v1/users",
      headers:{ 'Accept' => 'application/json' },
      parameters: {
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      password: params[:password]}
    ).body

    user = User.new(new_user)
    puts user
    if new_user["version"].to_i == 1
      session[:user_id] = user.id
      flash[:success] = 'Successfully created account!'
      redirect_to '/'
    else
      flash[:warning] = 'Invalid email or password!'
      redirect_to '/'
    end
  end

  def show
    @user = User.find(params[:id])
    if @user.id != current_user.id
      flash[:warning] = 'Access denied.'
      redirect_to '/login'
    else
      render 'show'
    end
  end

  def edit
    api_user = Unirest.get("http://localhost:3001/api/v1/users/#{params[:id]}").body
    @user = User.new(api_user)

  end

  def update
    user = Unirest.patch("http://localhost:3001/api/v1/users/#{params[:id]}",
      headers:{ 'Accept' => 'application/json' },
      parameters: { first_name: params[:first_name], last_name: params[:last_name],
        email: params[:email]})
    flash[:success] = 'Profile successfully updated'
    redirect_to '/'
  end
end
