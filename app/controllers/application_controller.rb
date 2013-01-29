class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!


  def after_sign_in_path_for(user)
    dashboard_path
  end

  def after_sign_out_path_for(user)
    categories_path
  end

  def encryptor
    secret = Digest::SHA1.hexdigest("yourpass")
    ActiveSupport::MessageEncryptor.new(secret)
  end

  def encrypt(message)
    e = encryptor
    e.encrypt(message)
  end

  def decrypt(message)
    e = encryptor
    e.decrypt(message)
  end
end
