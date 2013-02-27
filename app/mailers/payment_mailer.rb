class PaymentMailer < ActionMailer::Base
default :from => "info@osb.com"

  def payment_notification_email(current_user_email,client,invoice,payment)
    @client,@invoice, @amount = client,invoice, payment.payment_amount
    email_body =  mail(:to => client.email, :subject => "Payment notification").body.to_s
    payment.sent_emails.create({
    :content => email_body,
    :sender => current_user_email,    #User email
    :recipient => @client.email, #client email
    :subject => "Payment notification",
    :type => "Payment",
    :date => Date.today
         })
  end
end
