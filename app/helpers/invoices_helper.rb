module InvoicesHelper
  def new_invoice id, is_draft
    message = is_draft ? "The invoice has been saved as draft." : "Invoice has been created and sent to #{@invoice.client.organization_name}."
    notice = <<-HTML
       <p>#{message}.</p>
       <ul>
         <li><a href="/invoices/enter_single_payment?ids=#{id}">Enter payment against this invoice</a></li>
         <li><a href="/invoices/new">Create another invoice</a></li>
         <li><a href="/invoices/new?id=#{id}">Create another by duplicating this invoice</a></li>
         <li><a href="/invoices/invoice_pdf/#{id}.pdf" target="_blank">Download this invoice as PDF</a></li>
       </ul>
    HTML
    notice.html_safe
  end

  def invoices_archived ids
    notice = <<-HTML
     <p>#{ids.size} invoice(s) have been archived. You can find them under
     <a href="invoices/filter_invoices?status=archived" data-remote="true">Archived</a> section on this page.</p>
     <p><a href='invoices/undo_actions?ids=#{ids.join(",")}&archived=true&page=#{params[:page]}'  data-remote="true">Undo this action</a> to move archived invoices back to active.</p>
    HTML
    notice.html_safe
  end

  def invoices_deleted ids
    notice = <<-HTML
     <p>#{ids.size} invoice(s) have been deleted. You can find them under
     <a href="invoices/filter_invoices?status=deleted" data-remote="true">Deleted</a> section on this page.</p>
     <p><a href='invoices/undo_actions?ids=#{ids.join(",")}&deleted=true&page=#{params[:page]}'  data-remote="true">Undo this action</a> to move deleted invoices back to active.</p>
    HTML
    notice.html_safe
  end

  def payment_for_invoices ids
    notice = <<-HTML
     <p>Payments of ${amount} against <a>N invoices</a> have been recorded successfully.
     <a href="invoices/filter_invoices?status=deleted" data-remote="true">Deleted</a> section on this page.</p>
    HTML
    notice.html_safe
  end

  def dispute_invoice_message company_name
    notice = <<-HTML
     <p>Invoice disputed.</p>
     <p> #{company_name} has been notified of the dispute.</p>
    HTML
    notice.html_safe
  end

  def taxes_list list
    tax_list = ""
    for tax, amount in list
      tax_list += <<-HTML
      <div class="top_right_row"><div class="preview_right_label">#{tax}</div><div class="preview_right_description">#{number_to_currency(amount)}</div></div>
      HTML
    end
    tax_list.html_safe
  end

end
