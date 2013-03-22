class InvoiceMailer < ActionMailer::Base
  default :from => "info@osb.com"

  def new_invoice_email(client, invoice, e_id, current_user)
    @current_user, @e_id, @client, @invoice = current_user, e_id, client, invoice
    email_body = mail(:to => client.email, :subject => "New Invoice Added").body.to_s
    invoice.sent_emails.create({
                                   :content => email_body,
                                   :sender => @current_user.email, #User email
                                   :recipient => @client.email, #client email
                                   :subject => "New Invoice Added",
                                   :type => "Invoice",
                                   :date => Date.today
                               })
  end

  def due_date_reminder_email(invoice)
    @client, @invoice = invoice.client, invoice
    email_body = mail(:to => @client.email, :subject => "Due Date Reminder").body.to_s
    invoice.sent_emails.create({
                                   :content => email_body,
                                   :recipient => @client.email, #client email
                                   :subject => "Due Date Reminder",
                                   :type => "Reminder",
                                   :date => Date.today
                               })
  end
  def dispute_invoice_email(user, invoice, reason)
    @user, @invoice, @reason = user, invoice, reason
    mail(:to => user.email, :subject => "Invoice Disputed")
    invoice.sent_emails.create({
                                   :content => reason,
                                   :sender => invoice.client.email, #User email
                                   :recipient => user.email, #client email
                                   :subject => "Reason from client",
                                   :type => "Disputed",
                                   :date => Date.today
                               })
    invoice
  end
  def response_to_client(user, invoice, response)
    @user, @invoice, @response = user, invoice, response
    mail(:to => @invoice.client.email, :subject => "Invoice Undisputed")
    invoice.sent_emails.create({
                                   :content => response,
                                   :sender => user.email, #User email
                                   :recipient => invoice.client.email, #client email
                                   :subject => "Response to client",
                                   :type => "Disputed",
                                   :date => Date.today
                               })
  end

end
