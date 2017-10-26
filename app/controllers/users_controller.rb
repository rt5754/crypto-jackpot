class UsersController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, :js
  require 'bigdecimal'
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
    @games = Game.where(user_id: @user.id).paginate(page: params[:page],:per_page => 10)
    @games.reverse_order!
  end
  
  def addFunds
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to :back, :alert => "Access denied."
    end
    if @user.balance != nil
      @user.balance += BigDecimal(params[:amount])
    else
      @user.balance = BigDecimal.new("0.0")
    end
    @user.save
  end
  
  private
    def all_users
      @users = User.all
    end
  
end
