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

  def clients_archived ids
    notice = <<-HTML
     <p>#{ids.size} client(s) have been archived. You can find them under
     <a href="clients/filter_clients?status=archived" data-remote="true">Archived</a> section on this page.</p>
     <p><a href='clients/undo_actions?ids=#{ids.join(",")}&archived=true&page=#{params[:page]}'  data-remote="true">Undo this action</a> to move archived clients back to active.</p>
    HTML
    notice = notice.html_safe
  end

  def clients_deleted ids
    notice = <<-HTML
     <p>#{ids.size} client(s) have been deleted. You can find them under
     <a href="clients/filter_clients?status=deleted" data-remote="true">Deleted</a> section on this page.</p>
     <p><a href='clients/undo_actions?ids=#{ids.join(",")}&deleted=true&page=#{params[:page]}'  data-remote="true">Undo this action</a> to move deleted clients back to active.</p>
    HTML
    notice = notice.html_safe
  end

end
