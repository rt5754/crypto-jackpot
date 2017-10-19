class JackpotsController < ApplicationController
  protect_from_forgery
  respond_to :html, :js
  def current_jackpot
    @jackpot = Jackpot.last
  end
  
  def new
    @jackpot = Jackpot.new
  end
  
  def create
    @jackpot = Jackpot.new(jackpot_params) 
    @jackpot.save
  end
  
  def update
    @jackpot = Jackpot.find(params[:id])
    @user = User.find(User.current_user.id)
    if params.has_key?(:amount)
      if @jackpot.users.include? @user
        flash[:danger] = "You have already gone in on this pot"
      else
        @jackpot.users.push(@user)
        @jackpot.update(pot: @jackpot.pot + BigDecimal(params[:amount]))
        current_user.update(balance: current_user.balance - BigDecimal(params[:amount]))
      end
    end
    if @user
      balance = @user.balance.to_s
    else
      balance = "0"
    end
    respond_to do |format| 
      format.json { render json: { pot: @jackpot.pot, user_balance: balance } }
      format.js { render 'pages/jackpot.js.erb' }
    end
  end
  
  def endPot
    @jackpot.open = false
  end
  
  private
    
    def jackpot_params
      params[:pot] = 0.0
      params[:open] = true
      params.require(:jackpot).permit(:pot, :open, :amount)  
    end
  
end
