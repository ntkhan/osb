jQuery ->
  jQuery("#close_popup").live "click",->
    jQuery("#invoices_container").hide()
  jQuery(".paid_full").live "click",->
     full_value = jQuery(this).next('.full_payment_amount').attr('value')
     full_value_id = jQuery(this).next('.full_payment_amount').attr('id')
     if jQuery(this).is ":checked"
        jQuery('#payments_'+full_value_id+'_payment_amount').val(full_value)
        jQuery('#payments_'+full_value_id+'_payment_amount').attr('readonly','readonly')
     else
        jQuery('#payments_'+full_value_id+'_payment_amount').removeAttr('readonly')
        jQuery('#payments_'+full_value_id+'_payment_amount').val('')

