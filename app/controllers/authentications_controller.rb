class AuthenticationsController < ApplicationController
  skip_before_filter :ensure_authentication

   def create
    auth = request.env["omniauth.auth"]

    # Try to find authentication first
    authentication = get_authentication( auth)

    if authentication
      # Authentication found, sign the user in.
      flash[:notice] = "Signed in successfully."
      # Remembering user
      authenticate_user( auth)
      redirect_to( edit_user_path( authentication.user))
    else
      # Authentication not found, thus a find or create new user by email.
      user = User.find_or_initialize_by_email( (auth['info']['email'] rescue ''))
      user.apply_omniauth(auth)

      if user.save
        flash[:notice] = "Account created and signed in successfully."
        # Remembering user
        authenticate_user( auth)
        redirect_to( edit_user_path( user))
      else
        flash[:error] = "Error while creating a user account. Please try again."
        redirect_to root_path
      end
    end
  end
end
