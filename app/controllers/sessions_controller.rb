class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      token = JsonWebToken.encode(user_id: user.id)
      cookies.signed[:jwt] = { value: token, httponly: true, secure: Rails.env.production? }
      redirect_to root_path, notice: "Logged in successfully."
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    cookies.delete(:jwt)
    redirect_to root_path, notice: "Logged out successfully."
  end
end
