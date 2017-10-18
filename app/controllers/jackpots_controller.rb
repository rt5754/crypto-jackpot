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
    if params.has_key?(:amount)
      @jackpot.update(pot: @jackpot.pot + params[:amount].to_f)
    end
    respond_to do |format| 
      format.json { render json: { pot: @jackpot.pot } }
      format.js
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
