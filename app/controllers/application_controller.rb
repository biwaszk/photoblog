class ApplicationController < ActionController::Base
  protect_from_forgery
  # domyslnie wszystkie helpery sa dostepne w w widokach ale nie w kontrolerach
  # poniewaz metody z session_helper sa potrzebne w widoku i kontrolerze muszą być zaincludowane
  include ApplicationHelper
  include SessionsHelper
end
