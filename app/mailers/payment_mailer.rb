class PaymentMailer < ActionMailer::Base
  default :from => "info@osb.com"

  def payment_notification_email(current_user_email,user,invoice,amount)
    @user,@invoice, @amount = user,invoice, amount
    email_body =  mail(:to => user.email, :subject => "Payment notification").body
    sentemail = SentEmail.new
    sentemail.content = email_body
    sentemail.sender = current_user_email    #User email
    sentemail.recipient = @user.email #client email
    sentemail.subject = "Payment notification"
    sentemail.type = "Payment"
    sentemail.date = Date.today
    sentemail.save
  end
end
