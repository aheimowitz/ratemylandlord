#Controller for every page
class ApplicationController < ActionController::Base
  protect_from_forgery :with => :exception

  helper_method :current_user, :admin?, :time_format

  # Returns the current user
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  # Returns true if the user is signed in as an admin
  def admin?
    current_user && current_user.admin
  end

  # If the user is not an admin, redirect to another page and return false
  # otherwise return true
  def require_admin(page = '/')
    unless admin?
      flash[:error] = 'You do not have permission to access that page'
      redirect_to page
      return false
    end
    return true
  end

  # If the user is not signed in, redirect to another page and return false
  # otherwise return true
  def require_sign_in(id = nil, page = '/')
    unless current_user && (id.nil? || current_user.id == id)
      flash[:error] = 'You do not have permission to access that page'
      redirect_to page
      return false
    end
    return true
  end

  def time_format(time)
    time.in_time_zone("Eastern Time (US & Canada)").strftime("%m-%d-%y")
  end
end
