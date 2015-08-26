class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :humanize_name ,only: [:create,:update]

  def index
    # we verify inclusion of role first then metaprograming for choosing the rigth list to show
    # 's' added for readability in the model methods
    # if the request comes with search, get the role from the search and use it
    if params[:search]
      params[:role] = User::ROLES.include?(params[:search][:role]) ? "#{params[:search][:role]}" : 'resident'
    end
    @user_list = User::ROLES.include?(params[:role]) ? "#{params[:role]}" : 'resident'


    @users = (class_eval %Q{User.#{@user_list}}).search(sanitized_search).page params[:page]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new user_params
    # create method for generate password
    @user.password = '12345678'
    @user.password_confirmation = '12345678'
    respond_to do |format|
      if @user.save!
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url(role: params[:role]), notice: 'User was successfully destroyed.' }
    end
  end

  def edit_password
    @user = current_user
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update(password_params)
      # Sign in the user by passing validation in case their password changed
      sign_in @user, :bypass => true
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private
    def humanize_name
      params[:user][:name] = params[:user][:name].split.map(&:capitalize).join(' ')
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :phone, :email, :role)
    end

    def password_params
      params.require(:user).permit(:password,:password_confirmation)
    end
end
