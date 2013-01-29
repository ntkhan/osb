jQuery(".alert").show().find('span').html("Item(s) are <%= @action %> successfully");
jQuery('tbody#payment_body').html('<%= escape_javascript render("payment") %>');
jQuery('#active_links').html('<%= escape_javascript render("filter_links") %>');
