class Admin::UsersController < ApplicationController

  before_filter :restrict_admin_access

  def index
    max_per_page = 10
    num_users = User.count
    @max_pages = num_users / max_per_page
    @max_pages += 1 if (num_users % max_per_page) > 0
    session[:admin_users_page] ||= 1
    session[:admin_users_page] = 1 if session[:admin_users_page] < 1
    session[:admin_users_page] = @max_pages if session[:admin_users_page] > @max_pages
    @users_page = User.page(session[:admin_users_page]).per(max_per_page)
  end

  def next_page
    session[:admin_users_page] += 1
    redirect_to admin_users_path
  end

  def prev_page
    session[:admin_users_page] -= 1
    redirect_to admin_users_path
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    UserMailer.deletion_email(@user)
    destroyed_user_full_name = @user.full_name
    @user.destroy
    redirect_to admin_users_path, notice: "User: #{destroyed_user_full_name} destroyed."
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(admin_user_params)
    if @user.save
      redirect_to admin_users_path, notice: "User: #{@user.full_name} created."
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(admin_user_params)
      redirect_to admin_users_path, notice: "#User: {@user.full_name} updated."
    else
      render :edit
    end
  end

protected
  
  def restrict_admin_access
    @current_user = User.find(session[:user_id]) if session[:user_id]
    if (@current_user == nil) || (@current_user.admin != true)
      redirect_to movies_path
    end
  end

  def admin_user_params
    params.require(:user).permit(:email, :firstname, :lastname, :admin, :password, :password_confirmation)
  end

end
