jQuery(".alert").show().find('span').html("Client(s) are <%= @action %> successfully");
jQuery('tbody#client_body').html('<%= escape_javascript render("clients") %>');
jQuery('#active_links').html('<%= escape_javascript render("filter_links") %>');
jQuery('#select_all').attr('checked',false);
