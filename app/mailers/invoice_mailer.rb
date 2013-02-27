class InvoiceMailer < ActionMailer::Base
  default :from => "info@osb.com"

  def new_invoice_email(user,invoice,e_id,current_user)
    @current_user,@e_id,@user,@invoice = current_user,e_id,user,invoice
    email_body = mail(:to => user.email, :subject => "New Invoice Added").body.to_s
    sentemail = SentEmail.new
    sentemail.content = email_body
    sentemail.sender = @current_user.email    #User email
    sentemail.recipient = @user.email #client email
    sentemail.subject = "New Invoice Added"
    sentemail.type = "Invoice"
    sentemail.date = Date.today
    sentemail.save
  end

  def due_date_reminder_email(client, invoice ,current_user_email)
    @client,@invoice,@current_user_email = client,invoice,current_user_email
    mail(:to => client.email, :subject => "Due Date Reminder")
  end
end
