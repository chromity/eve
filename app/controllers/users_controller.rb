class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    @user.city = params[:city]
    if @user.save
      flash[:notice] = "You signed up successfully, please"
      flash[:color] = "valid"
      redirect_to "/users/new"
    else
      render "new"
    end
  end

  def event
    @user = User.find(params[:id])
  end


  def destroy
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    result = @user.update_attributes(user_params)
    if result
      redirect_to "/users/#{@user.id}"
      flash[:notice] = "User successfully updated"
      flash[:color] = "success"
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :location, :city, :password, :password_confirmation)
  end
end
