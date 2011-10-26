module SessionsHelper
  attr_writer :current_user

  #-------------------------------------------------------------------------------------- LOGOWANIE
  def sign_in(user)
    session[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  #------------------------------------------------------------------------------------- LOGOWANIE
  def current_user
    @current_user ||= user_from_remember_token
  end

  #------------------------------------------------------------------------------------- LOGOWANIE
  def signed_in?
    !current_user.nil?
  end

  #------------------------------------------------------------------------------------- LOGOWANIE
  def sign_out
    session.delete(:remember_token)
    self.current_user = nil
  end

  #----------------------------------------------------------------------------- UWIERZYTELNIANIE
  def authenticate
    deny_access unless signed_in?
  end

  #----------------------------------------------------------------------------- UWIERZYTELNIANIE
  def current_user?(user)
    user == current_user
  end

  #----------------------------------------------------------------------------- UWIERZYTELNIANIE
  def deny_access
    flash[:error] = "Wymagana rejestracja lub logowanie"
    redirect_to rejestracja_path
  end

  private#####################################################

    #------------------------------------------------------------------------------------ LOGOWANIE
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    #------------------------------------------------------------------------------------ LOGOWANIE
    def remember_token
      session[:remember_token] || [nil, nil]
    end

end
