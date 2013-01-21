class PaymentMailer < ActionMailer::Base
  default :from => "info@osb.com"

  def payment_notification_email(user,invoice,amount)
    @user,@invoice, @amount = user,invoice, amount
    mail(:to => user.email, :subject => "Payment notification")
  end
end
