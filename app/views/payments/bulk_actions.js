jQuery(".alert").hide()
<%if params[:payment_ids].blank? %>
jQuery(".alert.alert-error").show().find('span').html("No payment is selected.");
<% else %>
jQuery(".alert.alert-success").show().find('span').html("Payment(s) are <%= @action %> successfully");
<% end %>
jQuery('tbody#payment_body').html('<%= escape_javascript render("payment") %>');
jQuery('#active_links').html('<%= escape_javascript render("filter_links") %>');
jQuery('#select_all').attr('checked',false);
