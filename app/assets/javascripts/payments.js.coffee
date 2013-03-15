jQuery ->
  flag = true
  jQuery("#close_popup").live "click", ->
    jQuery("#invoices_container").hide()
  #Autocomplete amount field on paid full checkbox
  jQuery(".paid_full").live "click", ->
    rem_value = jQuery(this).next('.rem_payment_amount').attr('value')
    rem_value_id = jQuery(this).next('.rem_payment_amount').attr('id')
    if jQuery(this).is ":checked"
      jQuery('#payments_' + rem_value_id + '_payment_amount').val(rem_value)
      jQuery('#payments_' + rem_value_id + '_payment_amount').attr('readonly', 'readonly')
    else
      jQuery('#payments_' + rem_value_id + '_payment_amount').removeAttr('readonly')
      jQuery('#payments_' + rem_value_id + '_payment_amount').val('')

  #Select credit from method dropdown if apply from credit checkbox is checked
  jQuery(".apply_credit").live "click", ->
    apply_credit_id = jQuery(this).attr("id")
    payfull = jQuery(".paid_full")

    # make credit option selected in drop if credit checkbox is selected
    credit_selected = if jQuery(this).is ":checked" then "Credit" else ""
    jQuery("#payments_#{apply_credit_id}_payment_method").val(credit_selected).trigger("liszt:updated")

    # if amount due is greate or equal to credit then apply all credit
    credit = jQuery(this).parents('.payment_right').find('.rem_payment_amount');
    payment_field = jQuery("input#payments_#{credit.attr('id')}_payment_amount")
    if jQuery(this).is ":checked"
      credit_amount = parseFloat(jQuery(this).parents('.field_check').find('.credit_amount').text())
      amount_due = parseFloat(credit.attr('value'))
      if amount_due >= credit_amount
        payment_field.val(credit_amount.toFixed(2))
        if payfull.is ":checked"
         payfull.removeAttr('checked')
         payment_field.removeAttr('readonly')
      else if amount_due <= credit_amount
         payment_field.val(amount_due.toFixed(2))
    else
      payment_field.val('') unless payfull.is ":checked"

  jQuery('#submit_payment_form').live "click", ->
    flag = true
    jQuery(".apply_credit:checked").each ->
      pay_amount = parseFloat(jQuery("#payments_#{@id}_payment_amount").val())
      rem_credit = parseFloat(jQuery("#rem_credit_#{@id}").attr("value"))
      if pay_amount > rem_credit
        alert "Payment from credit cannot exceed available credit."
        flag = false
      else
        flag = true
    flag

  # validate payments fields on enter payment form submit
  jQuery('#payments_form').submit ->
    validate = true
    payment_fields = jQuery('.payment_amount')
    payment_fields.each ->
      unless jQuery(this).val()
        jQuery(this).qtip({content: text: "Enter payment amount", show: event: false, hide: event: false})
        jQuery(this).focus().qtip().show()
        validate = false
    validate

  # hide qtip when enter some text in payment field
  jQuery(".payment_amount").keyup ->
    jQuery(this).qtip("hide")

  # show intimation message on selection no invoice.
  jQuery('#invoice_selection').submit ->
    invoices = jQuery("table.table_listing tbody")
    flag = if invoices.find('tr.no-invoices').length
      jQuery("#invoice_popup_error").show().find('span').html('There are no unpaid invoices to enter payment against.')
      false
    else if invoices.find(":checked").length is 0
      jQuery("#invoice_popup_error").show().find('span').html("You haven't selected any invoice. Please select one or more invoices and try again.")
      false
    else
      true
   jQuery(".text-overflow-class").ellipsis row:2;