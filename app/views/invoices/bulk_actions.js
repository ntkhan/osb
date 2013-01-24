jQuery(".alert").show().find('span').html("Invoice(s) are <%= @action %> successfully");
jQuery('tbody#invoice_body').html('<%= escape_javascript render("invoice") %>');
