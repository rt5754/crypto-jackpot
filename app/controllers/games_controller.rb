class GamesController < ApplicationController
  before_action :set_jackpot, only: [:new, :create, :index]
  
  def create
    @game = @jackpot.games.new(game_params) do |g|
      g.user = User.current_user
    end
    if @jackpot.users.include? User.current_user
      ActionCable.server.broadcast 'jackpot_channel',
                                          error: "User already in pot"
    else
      if @game.save
        @jackpot = Jackpot.find(params[:jackpot_id])
        @jackpot.update(pot: @jackpot.pot + @game.user_stake)
        ActionCable.server.broadcast 'jackpot_channel',
                                          users: @jackpot.users,
                                          pot: @jackpot,
                                          user: User.find(@game.user_id),
                                          game: @game,
                                          stake: @game.user_stake.to_s,
                                          winchance: ((@game.user_stake / @jackpot.pot) * 100).round(2)
      else
        ActionCable.server.broadcast 'jackpot_channel',
                                          error: @game.errors.full_messages
      end
    end
  end
  
  def new
    @game = Game.new
  end
  
  private
  
    def set_jackpot
      @jackpot = Jackpot.find(params[:jackpot_id])
    end
  
    def game_params
      params.require(:game).permit(:user_stake, :user_id, :jackpot_id)
    end
end
