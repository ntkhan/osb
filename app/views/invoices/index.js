jQuery('tbody#invoice_body').html('<%= escape_javascript render("invoice") %>');
jQuery('.paginator').html('<%= escape_javascript(paginate(@invoices, :remote => true).to_s) %>' +
    '<div class="invoice_info"><%= page_entries_info @invoices %></div>');