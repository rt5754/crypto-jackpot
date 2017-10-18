class UsersController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, :js

  def index
    @users = User.all
  end
  
  def update
    @user.jackpot_id = params[:jackpot_id]
    if has_key?(:balance)
      @user.balance += params[:balance]
    end
  end

  def show
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to :back, :alert => "Access denied."
    end
  end
  
  def addFunds
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to :back, :alert => "Access denied."
    end
  end
  
  private
    def all_users
      @users = User.all
    end
  
end
