# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  jQuery(".chzn-select").chosen({allow_single_deselect: true}).on "liszt:showing_dropdown", ->
    chzn_drop = jQuery(this).next().find(".chzn-drop")
    unless chzn_drop.find("div.add-new").length > 0
      chzn_drop.append("<div class='add-new no_links'><a href=\'http://www.google.com\' target=\'_blank\' title='صبرکاپھل میٹھا'>Add New</a></div>")

  jQuery.tablesorter.addParser
    id: "thousands"
    is: (s) ->
      sp = s.replace(/,/, ".")
      test = (/([£$€] ?\d+\.?\d*|\d+\.?\d* ?)/.test(sp)) #check currency with symbol
      test
    format: (s) ->
      jQuery.tablesorter.formatFloat s.replace(new RegExp(/[^\d\.]/g), "")
    type: "numeric"

  # Apply sorting on invoice table
  jQuery("table.table_listing,table.report-data-table").tablesorter
    widgets: ['staticRow']
    sortList: [[1,1]]

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
    jQuery("#invoice_total_lbl").formatCurrency()

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
     #jQuery(this).popover "hide"

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
          container.find("input.description").val(item[0])
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
  jQuery("form.form-horizontal").submit ->
    item_rows = jQuery("table#invoice_grid_fields tr.fields:visible")
    flag = true
    # Check if client is selected
    if jQuery("#invoice_client_id").val() is ""
      applyPopover(jQuery("#invoice_client_id_chzn"),"bottomMiddle","topLeft","Select a client")
      flag = false
    # Check if item is selected
    else if item_rows.find("select.items_list option:selected[value='']").length is item_rows.length
      first_item = jQuery("table#invoice_grid_fields tr.fields:visible:first").find("select.items_list").next()
      applyPopover(first_item,"bottomMiddle","topLeft","Select an item")
      flag = false
    # Item cost and quantity should be greater then 0
    else
      jQuery("tr.fields:visible").each ->
        row = jQuery(this)
        if row.find("select.items_list").val() isnt ""
          cost = row.find(".cost")
          qty =  row.find(".qty")
          tax1 = row.find("select.tax1")
          tax2 = row.find("select.tax2")
          tax1_value = jQuery("option:selected",tax1).val()
          tax2_value = jQuery("option:selected",tax2).val()

          if cost.val() is ""
            applyPopover(cost,"bottomMiddle","topLeft","Enter item cost")
          else if cost.val() <= 0
            applyPopover(cost,"bottomLeft","topLeft","Unit cost should be greater then 0")
          else if not jQuery.isNumeric(cost.val())
            applyPopover(cost,"bottomLeft","topLeft","Enter valid Item cost")
          else hidePopover(cost)

          if qty.val() is ""
            applyPopover(qty,"bottomMiddle","topLeft","Enter item quantity")
          else if qty.val() <= 0
            applyPopover(qty,"bottomLeft","topLeft","Quantity should be greater then 0")
          else if not jQuery.isNumeric(qty.val())
            applyPopover(qty,"bottomLeft","topLeft","Enter valid Item quantity")
          else if (tax1_value is tax2_value) and (tax1_value isnt "" and tax2_value isnt "")
            applyPopover(tax2.next(),"bottomLeft","topLeft","Tax1 and Tax2 should be different")
            flag = false
          else hidePopover(qty)
          if cost.val() is "" or cost.val() <= 0 or not jQuery.isNumeric(cost.val()) or qty.val() is "" or qty.val() <= 0 or not jQuery.isNumeric(qty.val()) then flag = false
    flag

  applyPopover = (elem,position,corner,message) ->
#    elem.popover
#      trigger: "manual"
#      content: message
#      placement: position
#      template: "<div class='popover'><div class='arrow'></div><div class='popover-inner'><div class='popover-content alert-error'><p></p></div></div></div>"
#    elem.attr('data-content',message).popover "show"
#    elem.focus
    elem.qtip
      content:
        text: message
      show:
        event: false
      hide:
        event: false
      position:
        at: position
      style:
        tip:
          corner: corner
    elem.qtip().show()
    elem.focus()

  useAsTemplatePopover = (elem,id,client_name) ->
#    message =  "<a href='/invoices/new/#{id}'>To create new invoice use the last invoice send to '#{client_name}'.</a>"
#    elem.popover
#      trigger: "manual"
#      content: message
#      placement: "right"
#      template: "<div class='popover'><div class='arrow'></div><div class='popover-inner'><div class='popover-content alert-success'><p></p></div></div></div>"
#      html: true
#    elem.attr('data-content',message).popover "show"
    elem.qtip
      content:
        text: "<a href='/invoices/new/#{id}'>To create new invoice use the last invoice send to '#{client_name}'.</a>"
      show:
        event: false
      hide:
        event: false
      position:
        at: "bottomMiddle"
      style:
        tip:
          corner: "topLeft"
    elem.qtip().show()
    elem.focus()

  hidePopover = (elem) ->
    #elem.next(".popover").hide()
    elem.qtip("hide")

  jQuery("#invoice_client_id_chzn,.chzn-container").click ->
#    jQuery(this).popover "hide"
    jQuery(this).qtip("hide")

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

  # Load last invoice for client if any
  jQuery("#invoice_client_id").change ->
    client_id = jQuery(this).val()
    hidePopover(jQuery("#invoice_client_id_chzn")) if client_id is ""
    jQuery("#last_invoice").hide()
    if not client_id? or client_id isnt ""
      jQuery.ajax '/clients/get_last_invoice',
      type: 'POST'
      data: "id=" + client_id
      dataType: 'html'
      error: (jqXHR, textStatus, errorThrown) ->
        alert "Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        data = JSON.parse(data)
        id = jQuery.trim(data[0])
        client_name = data[1]
        unless id is "no invoice"
          useAsTemplatePopover(jQuery("#invoice_client_id_chzn"),id,client_name)
        else
          hidePopover(jQuery(".hint_text:eq(0)"))

  # tool tip on links not implemented yet
  jQuery(".no_links").attr("title", "This feature is not implemented yet.").qtip
    position:
      at: "bottomCenter"

  # tool tip on invoice statuses
  jQuery(".sent, .draft, .partial, .draft-partial, .paid, .disputed").qtip
    position:
      at: "bottomCenter"

 # Autofill due date
  jQuery("#invoice_payment_terms_id").change ->
    number_of_days = jQuery("option:selected",this).attr('number_of_days')
    if number_of_days?
     number_of_days = parseInt(number_of_days)
     invoice_invoice_date = new Date(jQuery("#invoice_invoice_date").val());
     invoice_due_date = new Date(invoice_invoice_date);
     invoice_due_date.setDate(invoice_due_date.getDate() + number_of_days);
     jQuery("#invoice_due_date").val(formated_date(invoice_due_date))
    else
     jQuery("#invoice_due_date").val("")


 # Date formating function
  formated_date = (elem) ->
   separator = "-"
   new_date  = elem.getFullYear() 
   new_date += separator + ("0" + (elem.getMonth() + 1)).slice(-2)
   new_date += separator + ("0" + elem.getDate()).slice(-2)
   new_date

  # Hide placeholder text on focus
  jQuery("input[type=text],input[type=number]",".quick_create_wrapper").live("focus",->
    @dataPlaceholder = @placeholder
    @removeAttribute "placeholder"
  ).live("blur", ->
    @placeholder = @dataPlaceholder
    @removeAttribute "dataPlaceholder"
  ).live "keypress", ->
    hidePopover(jQuery(this))

  # Show quick create popups under create buttons
  jQuery(".quick_create").click ->
    pos = $(this).position()
    height = $(this).outerHeight()
    jQuery('.quick_create_wrapper').hide()
    jQuery("##{jQuery(this).attr('name')}").css(
      position: "absolute"
      top: (pos.top + height) + "px"
      left: pos.left + "px"
    ).show()

  jQuery(".close_btn").live "click", ->
    jQuery(this).parents('.quick_create_wrapper').hide().find("input").qtip("hide")



