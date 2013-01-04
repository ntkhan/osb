# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  # Calculate the line total for invoice
  updateLineTotal = (elem) ->
    container = elem.parents("tr.fields")
    cost = parseFloat(jQuery(container).find("input.cost").val())
    qty = jQuery(container).find("input.qty").val()    
    line_total = (cost * qty)
    jQuery(container).find("input.line_total").val(line_total)

  # Calculate grand total from line totals
  updateInvoiceTotal = ->
    total = 0
    jQuery("table.invoice_grid_fields tr:visible .line_total").each ->
      total += parseFloat(jQuery(this).val())
      jQuery("input#invoice_sub_total").val(total)
      #tax = parseFloat(jQuery(container).find("input.tax1").val()) + parseFloat(jQuery(container).find("input.tax2").val())      
      jQuery(".invoice_balance #invoice_total").val(total)
      applyDiscount(total)
      #applyTax(total)

  # Apply discount percentage on subtotals
  applyDiscount = (subtotal) ->
    discount_percentage = jQuery("#invoice_discount_percentage").val()
    discount_percentage = 0 if not discount_percentage? or discount_percentage is ""    
    discount_amount = subtotal * (parseFloat(discount_percentage)/100)
    jQuery("#invoice_discount_amount").val(discount_amount * -1)
    invoice_total = jQuery(".invoice_balance #invoice_total")
    invoice_total.val(invoice_total.val() - discount_amount)

  # Apply Tax on subtotals
  applyTax = (subtotal) ->
    jQuery("table.invoice_grid_fields tr:visible").each ->
      tax = jQuery(this).find("input.tax1").val() + jQuery(this).find("input.tax2").val()
      alert tax

  # Update line and grand total if line item fields are changed
   jQuery("input.cost, input.qty, input.tax1, input.tax2").live "blur", (e) ->
     updateLineTotal(jQuery(this))
     updateInvoiceTotal()

  # Prevent form submission if enter key is press in cost,quantity or tax inputs.
   jQuery("input.cost, input.qty, input.tax1, input.tax2").live "keypress", (e) ->
     if e.which is 13
       e.preventDefault()
       false
  
  # Load Items data when an item is selected from dropdown list
   jQuery(".invoice_grid_fields select").live "change", ->
     elem = jQuery(this)
     jQuery.ajax '/items/load_item_data',
       type: 'POST'
       data: "id=" + jQuery(this).val()
       dataType: 'html'       
       error: (jqXHR, textStatus, errorThrown) ->
        alert "Error: #{textStatus}"
       success: (data, textStatus, jqXHR) ->
        item = JSON.parse(data)
        container = elem.parents("tr.fields")
        container.find("input.description").val(item[0])
        container.find("input.cost").val(item[1])
        container.find("input.qty").val(item[2])
        container.find("input.tax1").val(item[3])
        container.find("input.tax2").val(item[4])
        updateLineTotal(elem)
        updateInvoiceTotal()

  # Re calculate the total invoice balance if an item is removed
   jQuery(".remove_nested_fields").live "click", ->
    setTimeout (->
     updateInvoiceTotal()
    ), 100

  # Subtract discount percentage from subtotal
   jQuery("#invoice_discount_percentage").blur ->
     updateInvoiceTotal()