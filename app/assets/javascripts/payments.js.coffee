jQuery ->
  jQuery("#close_popup").live "click",->
    jQuery("#invoices_container").hide()
#Autocomplete amount field on paid full checkbox
  jQuery(".paid_full").live "click",->
     full_value = jQuery(this).next('.full_payment_amount').attr('value')
     full_value_id = jQuery(this).next('.full_payment_amount').attr('id')
     if jQuery(this).is ":checked"
        jQuery('#payments_'+full_value_id+'_payment_amount').val(full_value)
        jQuery('#payments_'+full_value_id+'_payment_amount').attr('disabled','disabled')
        jQuery('.rem_pay_'+full_value_id).removeAttr('disabled')
     else
        jQuery('.rem_pay_'+full_value_id).attr('disabled','disabled')
        jQuery('#payments_'+full_value_id+'_payment_amount').removeAttr('disabled')
        jQuery('#payments_'+full_value_id+'_payment_amount').val('')
#Select credit from method dropdown if apply from credit checkbox is checked
  jQuery(".apply_credit").live "click", ->
     apply_credit_id = jQuery(this).attr("id")
     if jQuery(this).is ":checked"
        jQuery("#payments" + apply_credit_id + "_payment_method").val "Credit"
     else
        jQuery("#payments" + apply_credit_id + "_payment_method").val ""
