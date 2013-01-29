jQuery(".alert").hide()
<% if @action == "paid invoices" %>
jQuery(".alert.alert-error").show().find('span').html("You cannot pay paid invoices");
<% elsif params[:invoice_ids].blank? %>
jQuery(".alert.alert-error").show().find('span').html("No invoice is selected.");
<% else %>
jQuery(".alert.alert-success").show().find('span').html("Invoice(s) are <%= @action %> successfully");
<% end %>
jQuery('tbody#invoice_body').html('<%= escape_javascript render("invoice") %>');
jQuery('#active_links').html('<%= escape_javascript render("filter_links") %>');
jQuery('#active_links a').removeClass('active');
<% if @action == "recovered from archived"%>
jQuery('.get_archived').addClass('active');
<% elsif @action == "recovered from deleted" %>
jQuery('.get_deleted').addClass('active');
<%else%>
jQuery('.get_actives').addClass('active');
<%end%>
jQuery('#select_all').attr('checked',false);
