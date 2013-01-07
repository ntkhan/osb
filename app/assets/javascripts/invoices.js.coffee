# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  # Calculate the line total for invoice
  updateLineTotal = (elem) ->
    container = elem.parents("tr.fields")
    cost = jQuery(container).find("input.cost").val()
    qty = jQuery(container).find("input.qty").val()
    cost = 0 if not cost? or cost is ""
    qty = 0 if not qty? or qty is ""
    line_total = (parseFloat(cost) * parseFloat(qty))
    jQuery(container).find(".line_total").text(line_total)

  # Calculate tax amount for line total
  lineTotalTax = (container) ->
    tax1 = container.find("input.tax1").val()
    tax2 = container.find("input.tax2").val()
    tax1 = 0 if not tax1? or tax1 is ""
    tax2 = 0 if not tax2? or tax2 is ""
    (parseFloat(tax1) + parseFloat(tax2))

  # Apply Tax on subtotals
  applyTax = (subtotal) ->
    total_tax = 0
    jQuery("table.invoice_grid_fields tr:visible").each ->
      total_tax += lineTotalTax(jQuery(this))
    tax_amount = subtotal * (parseFloat(total_tax) / 100)
    jQuery("#invoice_tax_amount_lbl").text(tax_amount)
    jQuery("#invoice_tax_amount").val(tax_amount)
    total_balance = parseFloat(jQuery("#invoice_total").text()) + tax_amount
    jQuery("#invoice_total").text(total_balance)
    

  # Calculate grand total from line totals
  updateInvoiceTotal = ->
    total = 0
    jQuery("table.invoice_grid_fields tr:visible .line_total").each ->
      total += parseFloat(jQuery(this).text())
      jQuery("#invoice_sub_total").val(total)
      jQuery("#invoice_sub_total_lbl").text(total)
      jQuery(".invoice_balance #invoice_total").text(total)
      applyDiscount(total)
      applyTax(total)

  # Apply discount percentage on subtotals
  applyDiscount = (subtotal) ->
    discount_percentage = jQuery("#invoice_discount_percentage").val()
    discount_percentage = 0 if not discount_percentage? or discount_percentage is ""    
    discount_amount = subtotal * (parseFloat(discount_percentage)/100)
    jQuery("#invoice_discount_amount_lbl").text(discount_amount * -1)
    jQuery("#invoice_discount_amount").val(discount_amount * -1)
    invoice_total = jQuery(".invoice_balance #invoice_total")
    invoice_total.text(invoice_total.text() - discount_amount)

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

  # Add date picker to invoice date field
   jQuery("#invoice_invoice_date").datepicker
     dateFormat: 'yy-mm-dd'

  # Makes the invoice line item list sortable
  jQuery("#invoice_grid_fields tbody").sortable
    handle: ".sort_icon"
    axis: "y"
