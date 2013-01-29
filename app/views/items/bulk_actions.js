jQuery(".alert").hide()
<%if params[:item_ids].blank? %>
jQuery(".alert.alert-error").show().find('span').html("No item is selected.");
<% else %>
jQuery(".alert.alert-success").show().find('span').html("Item(s) are <%= @action %> successfully");
<% end %>
jQuery('tbody#item_body').html('<%= escape_javascript render("items") %>');
jQuery('#active_links').html('<%= escape_javascript render("filter_links") %>');
jQuery('#select_all').attr('checked',false);
