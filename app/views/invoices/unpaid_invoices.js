jQuery("#invoices_container").show();
jQuery("#invoices_container").html("<%= escape_javascript(render(:partial=>"unpaid_invoices")) %>");

