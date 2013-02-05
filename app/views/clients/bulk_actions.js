jQuery(".alert").hide()
<%if params[:client_ids].blank? %>
 <%
  if @action == "recovered from archived" or @action == "recovered from deleted"
    no_msg = "Recover"
  else
    no_msg = "delete/archive"
  end
%>
jQuery(".alert.alert-error").show().find('span').html("You haven't selected any client to <%= no_msg %>. Please select one or more clients and try again.");
<% elsif @action == "archived" or @action == "deleted" %>
jQuery(".alert.alert-success").show().find('span').html("<%= escape_javascript @message %>");
<% else %>
jQuery(".alert.alert-success").show().find('span').html("Client(s) are <%= @action %> successfully");
<% end %>
<% unless params[:client_ids].blank? %>
jQuery('tbody#client_body').html('<%= escape_javascript render("clients") %>');
<%end%>
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
