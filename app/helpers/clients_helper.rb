module ClientsHelper
  def new_client id
    notice = <<-HTML
     <p>Client has been created successfully.</p>
     <ul>
      <li><a href="/clients/new">Create another client</a></li>
      <li><a href="/invoices/new?invoice_for_client=#{id}">Create an invoice for this client</a></li>
     </ul>

    HTML
    notice = notice.html_safe
  end
end
