class JackpotsController < ApplicationController
  protect_from_forgery
  respond_to :html, :js
  
  def current_jackpot
    @jackpot = Jackpot.last
  end
  
  def new
    @jackpot = Jackpot.new
  end
  
  def newPotInfo
    @jackpot = Jackpot.last
    respond_to do |format|
      format.json { render json: { potID: @jackpot.id} }
    end
  end
  
  def create
    @jackpot = Jackpot.new(:open => true, :pot => BigDecimal.new("0.0")) 
    @jackpot.save
  end
  
  def update
    @jackpot = Jackpot.find(params[:id])
    @user = User.find(User.current_user.id) if User.current_user
    if params.has_key?(:amount)
      if @jackpot.users.include? @user 
        flash[:danger] = "You have already gone in on this pot"
      elsif @jackpot.open = false
        flash[:danger] = "This pot has closed"
      else
        if @user 
          @jackpot.users.push(@user)
          @jackpot.update(pot: @jackpot.pot + BigDecimal(params[:amount]))
          User.current_user.update(balance: User.current_user.balance - BigDecimal(params[:amount]))
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
    
    if (time_left < 0) && (@jackpot.open)
      @jackpot.open = false
      @jackpot.save
      @tickets = []
      @users = @jackpot.users
      winner = draw_winner
      create
      respond_to do |format| 
        format.html { render :partial => "jackpots/jackpot" }
      end
    else
      respond_to do |format| 
        format.html { render :partial => "jackpots/jackpot" }
      end
    end
    
  end
  
  def endPot
    @jackpot.open = false
  end
  
  def draw_winner
    @tickets = []
    @users = @jackpot.users
    prng = Random.new
    rand = prng.rand(0..(@users.count - 1))
    return @users[rand]
  end
  
  def time_left
    @jackpot = Jackpot.find(params[:id])
    @game = Game.where(jackpot_id: @jackpot.id).first
    @game2 = Game.where(jackpot_id: @jackpot.id).second
    if @game && @game2
      return (20) - (Time.now - @game2.created_at).round(0)
    else
      return 300
    end
  end

  private
    
    def jackpot_params
      params.require(:jackpot).permit(:pot, :open, :amount)  
    end
  
end
