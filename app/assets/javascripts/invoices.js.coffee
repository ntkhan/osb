# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  jQuery(".chzn-select").chosen({allow_single_deselect: true})
  # Calculate the line total for invoice
  updateLineTotal = (elem) ->
    container = elem.parents("tr.fields")
    cost = jQuery(container).find("input.cost").val()
    qty = jQuery(container).find("input.qty").val()
    cost = 0 if not cost? or cost is "" or not jQuery.isNumeric(cost)
    qty = 0 if not qty? or qty is "" or not jQuery.isNumeric(qty)
    line_total = ((parseFloat(cost) * parseFloat(qty))).toFixed(2)
    jQuery(container).find(".line_total").text(line_total)

  # Calculate grand total from line totals
  updateInvoiceTotal = ->
    total = 0
    tax_amount = 0
    discount_amount = 0
    jQuery("table.invoice_grid_fields tr:visible .line_total").each ->
      line_total = parseFloat(jQuery(this).text())
      total += line_total
      jQuery("#invoice_sub_total").val(total.toFixed(2))
      jQuery("#invoice_sub_total_lbl").text(total.toFixed(2))
      jQuery("#invoice_invoice_total").val(total.toFixed(2))
      jQuery("#invoice_total_lbl").text(total.toFixed(2))
      tax_amount += applyTax(line_total,jQuery(this))
    discount_amount = applyDiscount(total)
    jQuery("#invoice_tax_amount_lbl").text(tax_amount.toFixed(2))
    jQuery("#invoice_tax_amount").val(tax_amount.toFixed(2))
    jQuery("#invoice_discount_amount_lbl").text((discount_amount * -1).toFixed(2))
    jQuery("#invoice_discount_amount").val((discount_amount * -1).toFixed(2))
    total_balance = (parseFloat(jQuery("#invoice_total_lbl").text() - discount_amount) + tax_amount)
    jQuery("#invoice_invoice_total").val(total_balance.toFixed(2))
    jQuery("#invoice_total_lbl").text(total_balance.toFixed(2))

  # Apply Tax on totals
  applyTax = (line_total,elem) ->
    tax1 = elem.parents("tr").find("select.tax1 option:selected").attr('data-tax_1')
    tax2 = elem.parents("tr").find("select.tax2 option:selected").attr('data-tax_2')
    tax1 = 0 if not tax1? or tax1 is ""
    tax2 = 0 if not tax2? or tax2 is ""
    discount_amount = applyDiscount(line_total)
    total_tax = (parseFloat(tax1) + parseFloat(tax2))
    ((line_total - discount_amount) * (parseFloat(total_tax) / 100))

  # Apply discount percentage on subtotals
  applyDiscount = (subtotal) ->
    discount_percentage = jQuery("#invoice_discount_percentage").val()
    discount_percentage = 0 if not discount_percentage? or discount_percentage is ""
    (subtotal * (parseFloat(discount_percentage)/100))

  # Update line and grand total if line item fields are changed
   jQuery("input.cost, input.qty").live "blur", ->
     updateLineTotal(jQuery(this))
     updateInvoiceTotal()

   jQuery("input.cost, input.qty").live "keyup", ->
     updateLineTotal(jQuery(this))
     updateInvoiceTotal()
#     jQuery(this).popover "hide"

  # Update line and grand total when tax is selected from dropdown
   jQuery("select.tax1, select.tax2").live "change", ->
     updateInvoiceTotal()

  # Prevent form submission if enter key is press in cost,quantity or tax inputs.
   jQuery("input.cost, input.qty").live "keypress", (e) ->
     if e.which is 13
       e.preventDefault()
       false

  # Load Items data when an item is selected from dropdown list
   jQuery(".invoice_grid_fields select.items_list").live "change", ->
     # Add an empty line item row at the end if last item is changed.
     elem = jQuery(this)
     addLineItemRow(elem)
     if elem.val() is ""
       clearLineTotal(elem)
       false
     else
       jQuery.ajax '/items/load_item_data',
         type: 'POST'
         data: "id=" + jQuery(this).val()
         dataType: 'html'
         error: (jqXHR, textStatus, errorThrown) ->
          alert "Error: #{textStatus}"
         success: (data, textStatus, jqXHR) ->
          item = JSON.parse(data)
          container = elem.parents("tr.fields")
          container.find("textarea.description").val(item[0])
          container.find("input.cost").val(item[1].toFixed(2))
          container.find("input.qty").val(item[2])
          updateLineTotal(elem)
          updateInvoiceTotal()

  # Add empty line item row
  addLineItemRow = (elem) ->
   if elem.parents('tr.fields').next('tr.fields:visible').length is 0
    jQuery(".add_nested_fields").click()
    jQuery(".chzn-select").chosen({allow_single_deselect: true})

  jQuery(".add_nested_fields").live "click", ->
    setTimeout (->
     jQuery(".chzn-select").chosen({allow_single_deselect: true})
    ), 0

 # Re calculate the total invoice balance if an item is removed
  jQuery(".remove_nested_fields").live "click", ->
    setTimeout (->
     updateInvoiceTotal()
    ), 100

  # Subtract discount percentage from subtotal
  jQuery("#invoice_discount_percentage").blur ->
     updateInvoiceTotal()

  # Don't allow nagetive value for discount
  jQuery("#invoice_discount_percentage,.qty").keydown (e) ->
     if e.keyCode is 109 or e.keyCode is 13
       e.preventDefault()
       false

  # Don't allow paste and right click in discount field
  jQuery("#invoice_discount_percentage,.qty").bind "paste contextmenu", (e) ->
     e.preventDefault()

  # Add date picker to invoice date field
  jQuery("#invoice_invoice_date").datepicker
     dateFormat: 'yy-mm-dd'

  # Makes the invoice line item list sortable
  jQuery("#invoice_grid_fields tbody").sortable
    handle: ".sort_icon"
    items: "tr.fields"
    axis: "y"

  # Calculate line total and invoice total on page load
  jQuery(".invoice_grid_fields tr:visible .line_total").each ->
    updateLineTotal(jQuery(this))
  updateInvoiceTotal()

  # Validate client, cost and quantity on invoice save
  jQuery("form#new_invoice").submit ->
    item_rows = jQuery("table#invoice_grid_fields tr.fields:visible")
    flag = true
    # Check if client is selected
    if jQuery("#invoice_client_id").val() is ""
      applyPopover(jQuery("#invoice_client_id_chzn"),"top","Select a client")
      flag = false
    # Check if item is selected
    else if item_rows.find("select.items_list option:first:selected").length is item_rows.length
      first_item = jQuery("table#invoice_grid_fields tr.fields:visible:first").find("select.items_list").next()
      applyPopover(first_item,"left","Select an item")
      flag = false
    # Item cost and quantity should be greater then 0
    else
      jQuery("tr.fields:visible").each ->
        row = jQuery(this)
        if row.find("select.items_list").val() isnt ""
          cost = row.find(".cost")
          qty =  row.find(".qty")
          if cost.val() is ""
            applyPopover(cost,"left","Enter item cost")
          else if cost.val() <= 0
            applyPopover(cost,"left","Item cost should be greater then 0")
          else if not jQuery.isNumeric(cost.val())
            applyPopover(cost,"left","Enter valid Item cost")
          else hidePopover(cost)

          if qty.val() is ""
            applyPopover(qty,"right","Enter item quantity")
          else if qty.val() <= 0
            applyPopover(qty,"right","Quantity should be greater then 0")
          else if not jQuery.isNumeric(qty.val())
            applyPopover(qty,"left","Enter valid Item quantity")
          else hidePopover(qty)
          if cost.val() is "" or cost.val() <= 0 or not jQuery.isNumeric(cost.val()) or qty.val() is "" or qty.val() <= 0 or not jQuery.isNumeric(qty.val()) then flag = false
    flag

  applyPopover = (elem,position,message) ->
    elem.popover
      trigger: "manual"
      content: message
      placement: position
      template: '<div class="popover"><div class="arrow"></div><div class="popover-inner"><div class="popover-content alert-error"><p></p></div></div></div>'
    elem.attr('data-content',message).popover "show"
    elem.focus

  hidePopover = (elem) ->
    elem.next(".popover").hide()

  jQuery("#invoice_client_id_chzn,.chzn-container").click ->
    jQuery(this).popover "hide"

  # Don't send an ajax request if an item is deselected.
  clearLineTotal = (elem) ->
    container = elem.parents("tr.fields")
    container.find("textarea.description").val('')
    container.find("input.cost").val('')
    container.find("input.qty").val('')
    updateLineTotal(elem)
    updateInvoiceTotal()

  # Check all checkboxes using from main checkbox
  jQuery('#select_all').click ->
    jQuery(this).parents('table.table_listing').find(':checkbox').attr('checked', this.checked)

  jQuery(".alert button.close").click ->
    jQuery(this).parent(".alert").hide()


 # Check all invoice checkboxes using from main checkbox
  jQuery('#main-invoice-checkbox').live "click", ->
     jQuery(this).parents('table.table-striped').find(':checkbox').attr('checked', this.checked)

  jQuery('#active_links a').live 'click', ->
     jQuery('#active_links a').removeClass('active')
     jQuery(this).addClass('active')

  jQuery(".invoice_action_links input[type=submit]").click ->
    jQuery(this).parents("FORM:eq(0)").find("table.table_listing").find(':checkbox').attr()


