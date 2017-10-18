class PagesController < ApplicationController
  respond_to :html, :js
  protect_from_forgery
  
  def home
    @jackpot = Jackpot.last
    gon.watch.pot = @jackpot.pot
  end
  
end
