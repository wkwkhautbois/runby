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

  def current_account
    @account ||= Account.find_by(name: session[:account_name])
  end

  def check_login
    if not logged_in?
      flash[:warning] = "ログインが必要です"
      redirect_to login_url
    end
  end
end
