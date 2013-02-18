
# Inline form handling inside Chosen list
class window.InlineForms
  FORM_SELECTORS = {
    "invoice_client_id": "#clients_holder form#create_client",
    "invoice_payment_terms_id": "#terms_holder form#create_term",
    "invoice_client_id": "#clients_holder form#create_client",
    "invoice_client_id": "#clients_holder form#create_client",
  }
  constructor: (@dropdownId) ->
    @formContainerId = jQuery("##{@dropdownId}").attr("data-form-container")
    @chznContainer = jQuery("##{@dropdownId}_chzn")
    @chznResults = @chznContainer.find(".chzn-results")
    @addNewRecordButton = @chznContainer.find(".add-new")
    @inlineForm = ""

  showForm: ->
    # code to show form
    @addFormToList()
    # hide chosen list
    @chznResults.hide()
    # hide add new button
    @addNewRecordButton.hide()
    # Show form
    @inlineForm.show()
    # bind the hideForm to form's close button
    @chznContainer.find(".close_btn").live "click", (e) =>
      @hideForm(jQuery(e.target))

  hideForm: (closeButton) =>
    closeButton.parents(".chzn-drop").find(".chzn-results").show()
    closeButton.parents(".chzn-drop").find(".add-new").show()

  addFormToList: =>
    # clone the form from DOM and append in chozen list and set the inlineForm
    @chznResults.after(jQuery("##{@formContainerId}").parent().clone().wrap('<p>').parent().html())
    @inlineForm = @chznResults.next()
