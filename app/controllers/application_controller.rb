class ApplicationController < ActionController::Base
  protect_from_forgery

  # ensure authentication to all controllers
  before_filter :ensure_authentication

  # make method available to views
  helper_method :signed_in?

  def ensure_authentication
    signed_in? ? true : redirect_to( root_path, error: 'You are not signed in.')
  end

  def signed_in?
    if( session[ :oauth].present? && session[ :oauth].kind_of?( Hash) && get_authentication( session[ :oauth]).present?)
      true
    else
      false
    end
  end

  def authenticate_user( _auth)
    session[ :oauth] = {provider: _auth[ :provider], uid: _auth[ :uid] }
  end

  def sign_out
    session.clear
  end

  def get_authentication( _arg = {})
    _arg.symbolize_keys!
    Authentication.find_by_provider_and_uid( _arg[:provider], _arg[:uid])
  end

end
