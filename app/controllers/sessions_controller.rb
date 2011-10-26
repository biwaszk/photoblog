class SessionsController < ApplicationController

  #-----------------------------------------------------------------------------------------------------
  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      flash[:error] = "Uwaga ! - Wprowadzono niepoprawne dane"
      redirect_to root_path
    else
      sign_in user
      redirect_to user
    end
  end

  #-----------------------------------------------------------------------------------------------------
  def destroy
    sign_out
    redirect_to root_path
  end
  
end
