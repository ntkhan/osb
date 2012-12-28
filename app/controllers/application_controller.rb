class ApplicationController < ActionController::Base
  protect_from_forgery



  def after_sign_in_path_for(user)
    clients_path
  end

  #def after_sign_out_path_for(user)
  #  categories_path
  #end

end
