class PagesController < ApplicationController
  respond_to :html, :js, :json
  protect_from_forgery
  
  def home
    @jackpot = Jackpot.last
    @game = Game.new
    if current_user
      @user = current_user
    end
    respond_to do |format|
      format.html { render 'home' }
      format.js { render 'home' } 
    end
    
  end
  
end
