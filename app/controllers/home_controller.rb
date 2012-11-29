class HomeController < ApplicationController
  skip_before_filter :ensure_authentication

  def index
    sign_out
  end
end
