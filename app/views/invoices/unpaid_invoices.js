//jQuery("#invoices_container").show();
jQuery(".modal-body").html("<%= escape_javascript(render(:partial=>"unpaid_invoices")) %>");


