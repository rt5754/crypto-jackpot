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
    @user = User.find(User.current_user.id) if User.current_user
    if params.has_key?(:amount)
      if @jackpot.users.include? @user
        flash[:danger] = "You have already gone in on this pot"
      else
        if @user
          @jackpot.users.push(@user)
          @jackpot.update(pot: @jackpot.pot + BigDecimal(params[:amount]))
          current_user.update(balance: User.current_user.balance - BigDecimal(params[:amount]))
          @game = Game.where(user_id: @user.id, jackpot_id: @jackpot.id)
          @game.update(user_stake: BigDecimal(params[:amount]))
        end
      end
    end
    if @user
      balance = @user.balance.to_s
    else
      balance = "0.000"
    end
    respond_to do |format| 
      format.json { render json: { pot: @jackpot.pot, user_balance: balance, time: time_left } }
      format.js { render 'pages/jackpot.js.erb' }
    end
  end
  
  def endPot
    @jackpot.open = false
  end
  
  def time_left
    @jackpot = Jackpot.find(params[:id])
    @game = Game.where(jackpot_id: @jackpot.id).first
    @game2 = Game.where(jackpot_id: @jackpot.id).second
    if @game && @game2
      return (60 * 5) - (Time.now - @game2.created_at).round(0)
    else
      return "300"
    end
  end

  
  private
    
    def jackpot_params
      params[:pot] = BigDecimal.new("0.0")
      params[:open] = true
      params.require(:jackpot).permit(:pot, :open, :amount)  
    end
  
end
