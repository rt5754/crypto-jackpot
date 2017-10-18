module PagesHelper
  def update_balance(amount)
    amount = 1.23453 + current_user.balance
    current_user.update(:balance => amount)
  end
  
end
