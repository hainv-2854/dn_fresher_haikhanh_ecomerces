module SessionsHelper
  def log_in user
    session[:user_id] = user.id
    session[:user_name] = user.name
  end

  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    session.delete :user_id
    session.delete :user_name
    @current_user = nil
  end

  def add_to_cart product_id, quantity
    quantity_card = current_cart[product_id.to_s] || 0
    quantity_card += quantity.to_i
    current_cart[product_id.to_s] = quantity_card
  end

  def current_cart
    session[:cart] ||= {}
  end
end
