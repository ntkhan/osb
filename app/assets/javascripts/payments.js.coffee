jQuery ->
  jQuery("#close_popup").live "click",->
    jQuery("#invoices_container").hide()
#Autocomplete amount field on paid full checkbox
  jQuery(".paid_full").live "click",->
     rem_value = jQuery(this).next('.rem_payment_amount').attr('value')
     rem_value_id = jQuery(this).next('.rem_payment_amount').attr('id')
     if jQuery(this).is ":checked"
        jQuery('#payments_'+rem_value_id+'_payment_amount').val(rem_value)
        jQuery('#payments_'+rem_value_id+'_payment_amount').attr('readonly','readonly')
     else
        jQuery('#payments_'+rem_value_id+'_payment_amount').removeAttr('readonly')
        jQuery('#payments_'+rem_value_id+'_payment_amount').val('')
#Select credit from method dropdown if apply from credit checkbox is checked
  jQuery(".apply_credit").live "click", ->
     apply_credit_id = jQuery(this).attr("id")
     if jQuery(this).is ":checked"
        jQuery("#payments" + apply_credit_id + "_payment_method").val "Credit"
     else
        jQuery("#payments" + apply_credit_id + "_payment_method").val ""
  jQuery('#submit_payment_form').live "click", ->
     flag = true
     jQuery(".apply_credit:checked").each ->
       pay_amount = jQuery("#payments" + this.id + "_payment_amount").val()
       rem_credit = jQuery("#rem_credit" + this.id).attr("value")
       if pay_amount > rem_credit
          alert "Payment from credit cannot exceed available credit."
          flag = false
       else
          flag = true
     flag

