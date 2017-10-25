class JackpotsController < ApplicationController
  protect_from_forgery
  respond_to :html, :js
  
  def current_jackpot
    @jackpot = Jackpot.last
  end
  
  def new
    @jackpot = Jackpot.new
  end
  
  def show
    @jackpot = Jackpot.find(params[:id])
  end
  
  def pot_info
    @jackpot = Jackpot.last
    respond_to do |format|
      if User.current_user
        format.json { render json: { potID: @jackpot.id, potSize: @jackpot.pot, 
        time: time_left, user_balance: User.current_user.balance, pot_open: @jackpot.open} }
      else
        format.json { render json: { potID: @jackpot.id, potSize: @jackpot.pot, 
        time: time_left, pot_open: @jackpot.open} }
      end
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
      elsif @jackpot.open == false
        flash[:danger] = "This pot has closed"
      else
        if @user 
          @jackpot.users.push(@user)
          @jackpot.update_attributes(pot: @jackpot.pot + BigDecimal(params[:amount]), open: true, winner_id: @jackpot.winner_id)
          User.current_user.update(balance: User.current_user.balance - BigDecimal(params[:amount]))
          @game = Game.where(user_id: @user.id, jackpot_id: @jackpot.id)
          @game.update(user_stake: BigDecimal(params[:amount]))
        end
      end
    end
    
    if (time_left < 0)
      draw_winner
      @jackpot.open = false
      @jackpot.winner_id = @winner.id
      @jackpot.save
      create
    else
    end
    
  end
  
  def endPot
    @jackpot.open = false
  end
  
  def draw_winner
    @user_tickets = 0
    @tickets = []
    @users = @jackpot.users
    @users.each do |user|
      @game = Game.where(jackpot_id: @jackpot.id, user_id: user.id).first
      @user_tickets = @game.user_stake * 100000
      for i in 1..@user_tickets do 
        @tickets.push(user)  
      end
    end
    prng = Random.new
    rand = prng.rand(0..@tickets.length)
    @winner = @tickets[rand]
    return @winner
  end
  
  def time_left
    @jackpot = Jackpot.last
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
