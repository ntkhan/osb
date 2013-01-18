class InvoiceMailer < ActionMailer::Base
  default :from => "info@osb.com"

  def new_invoice_email(user,invoice,e_id,current_user)
    @current_user,@e_id,@user,@invoice = current_user,e_id,user,invoice
    mail(:to => user.email, :subject => "New Invoice Added")
  end
end
