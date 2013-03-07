# taxes by category
# @example
#   GST 9%  1,200
#   VAT 3%    400
#   ABC 6     800

# itrate to line items
window.taxByCategory = ->
  taxes = []
  jQuery("table.invoice_grid_fields tr:visible").each ->
    # TODO: apply discount on lineTotal
    lineTotal = parseFloat $(this).find(".line_total").text()
    tax1Select = $(this).find("select.tax1 option:selected")
    tax2Select = $(this).find("select.tax2 option:selected")

    # calculate tax1
    tax1Name = tax1Select.text()
    tax1Pct = parseFloat tax1Select.attr "data-tax_1"
    tax1Amount = lineTotal * tax1Pct / 100

    # calculate tax2
    tax2Name = tax2Select.text()
    tax2Pct = parseFloat tax2Select.attr "data-tax_2"
    tax2Amount = lineTotal * tax2Pct / 100.0

    taxes.push {name: tax1Name, pct: tax1Pct, amount: tax1Amount} if tax1Name && tax1Pct && tax1Amount
    taxes.push {name: tax2Name, pct: tax2Pct, amount: tax2Amount} if tax2Name && tax2Pct && tax2Amount

  tlist = {}

  for t in taxes
    tlist["#{t['name']} #{t['pct']}%"] = (tlist[t["name"]] || 0) + t["amount"]

  li = ""
  for tax, amount of tlist
    li += "<li><span class='tax_name_in_totals'>#{tax}</span>, <span class='tax_amount_in_totals'>#{amount}</span></li>\n"

  li