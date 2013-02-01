jQuery(".alert").hide()
<%if params[:payment_ids].blank? %>
jQuery(".alert.alert-error").show().find('span').html("You haven't selected any payment to delete/archive. Please select one or more payments and try again.");
<% elsif @action == "archived" or @action == "deleted" %>
jQuery(".alert.alert-success").show().find('span').html("<%= escape_javascript @message %>");
<% else %>
jQuery(".alert.alert-success").show().find('span').html("Payment(s) are <%= @action %> successfully");
<% end %>
jQuery('tbody#payment_body').html('<%= escape_javascript render("payment") %>');
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
