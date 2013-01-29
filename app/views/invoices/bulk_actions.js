<% if @action == "paid invoices" %>
jQuery(".alert").show().find('span').html("You cannot pay paid invoices");
<% elsif params[:invoice_ids].blank? %>
jQuery(".alert").show().find('span').html("No invoice is selected.");
<% else %>
jQuery(".alert").show().find('span').html("Invoice(s) are <%= @action %> successfully");
<% end %>
jQuery('tbody#invoice_body').html('<%= escape_javascript render("invoice") %>');
jQuery('#active_links').html('<%= escape_javascript render("filter_links") %>');
jQuery('#select_all').attr('checked',false);
