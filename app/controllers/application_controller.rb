class ApplicationController < ActionController::Base
  helper_method :logged_in?

  def logged_in?
    !session[:account_name].nil?
  end

  def login(account)
    reset_session
    session[:account_name] = account.name
  end

  def logout
    reset_session
  end
end
