<% unless params[:invoice_ids].blank? %>
jQuery(".alert").show().find('span').html("Invoice(s) are <%= @action %> successfully");
<% else %>
jQuery(".alert").show().find('span').html("No invoice is selected.");
<% end %>
jQuery('tbody#invoice_body').html('<%= escape_javascript render("invoice") %>');
jQuery('#active_links').html('<%= escape_javascript render("filter_links") %>');
