//jQuery(".alert").show().find('span').html("Invoice(s) are <%= @action %> successfully");
jQuery('tbody#invoice_body').hide(200, function(){jQuery(this).html('<%= escape_javascript render("invoice") %>').show(500);});
