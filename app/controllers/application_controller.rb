class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :sprint

  protected

  def sprint
    @sprint ||= Sprint.for_date(date)
  end

  def date
    Date.parse(params[:date].presence || Date.today.to_s)
  end

end
