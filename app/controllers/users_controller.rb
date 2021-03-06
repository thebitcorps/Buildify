class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_user, only: [:show, :edit, :update, :destroy,:update_lock]
  before_action :humanize_name ,only: [:create,:update]

  def index
    # we verify inclusion of role first then metaprograming for choosing the rigth list to show
    # 's' added for readability in the model methods
    # if the request comes with search, get the role from the search and use it

    # I don't know, this kind of logic is for the model. Rob. 
    if params[:search]
      params[:role] = User::ROLES.include?(params[:search][:role]) ? "#{params[:search][:role]}" : 'subordinates'
    end
    @user_list = User::ROLES.include?(params[:role]) ? "#{params[:role]}" : 'subordinate'

    @users = (class_eval %Q{User.#{@user_list.pluralize}}).search(sanitized_search).page params[:page]
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
    @user = User.new(creation_params)
    @user.change_role role_param
    respond_to do |format|
      if @user.save
        @user.add_role role_param # possible bug, implementing before_create callback
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      @user.change_role role_param
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

  def update_lock
    if @user.change_lock_status
      redirect_to user_path(@user),notice: "Usuario a sido #{@user.access_locked? ? 'bloqueado' : 'desbloqueado'}"
    else
      redirect_to user_path(@user),notice: 'Error en intento de bloqueo de usuario'
    end

  end

  private
    def humanize_name
      params[:user][:name] = params[:user][:name].split.map(&:capitalize).join(' ')
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :phone, :email)
    end

    def role_param
      params[:user][:roles]
    end

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def creation_params
      params.require(:user).permit(:name, :phone, :email, :password, :password_confirmation, :roles_ids)
    end
end
