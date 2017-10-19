class PagesController < ApplicationController
  respond_to :html, :js, :json
  protect_from_forgery
  
  def home
    @jackpot = Jackpot.last
    if current_user
      @user = current_user
    end
    respond_to do |format|
      format.json { render json: { potID: @jackpot.id } }
      format.html { render 'home' }
    end
    
  end
  
end
