class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :confirmable, :validatable, :confirmable,
    :encryptable, :encryptor => :restful_authentication_sha1

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  belongs_to :company

  def currency_symbol
    # self.company.currency_symbol
    "$"
  end

  def currency_code
    # self.company.currency_code
    "USD"
  end

end
