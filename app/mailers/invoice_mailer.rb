class InvoiceMailer < ActionMailer::Base
  default :from => "info@osb.com"

  def new_invoice_email(user,invoice)
    @user,@invoice = user,invoice
    mail(:to => user.email, :subject => "New Invoice Added")
  end
end
