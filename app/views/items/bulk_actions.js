jQuery(".alert").show().find('span').html("Item(s) are <%= @action %> successfully");
jQuery('tbody#item_body').html('<%= escape_javascript render("items") %>');
jQuery('#active_links').html('<%= escape_javascript render("filter_links") %>');
jQuery('#select_all').attr('checked',false);
