# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  jQuery(".chzn-select").chosen({allow_single_deselect: true})
  jQuery("#contact").click ->
    jQuery("#adCntcts").toggle 500, ->
      action = $(this).find("#action")
      action_text = jQuery(action).html()
      action_text = (if action_text == "expand" then "collaps" else "expand")
      $(this).find("#id").html action_text;
  jQuery("#detail").click ->
    jQuery("#add_Detail").toggle 500, ->
      action = $(this).find("#action")
      action_text = (if jQuery(action).html() == "expand" then "collaps" else "expand")
      $(this).find("#id").html action_text;
  jQuery("#submit_form").click ->
    jQuery("#newClient").submit()

  # Validate client
#  jQuery("form#newClient,form#create_client").submit ->
#    flag = true
#    pattern = /^\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b$/i
#    client_email = jQuery("#client_email").val()
#    if client_email is ""
#      applyPopover(jQuery("#client_email"),"Email is required")
#      flag = false
#    else unless pattern.test(client_email)
#      applyPopover(jQuery("#client_email"),"Invalid email")
#      flag = false
#    else if jQuery("#client_organization_name").val() is ""
#      jQuery("#client_organization_name").val(client_email)
#    else
#      hidePopover(jQuery("#client_email"))
#    flag

#	jQuery(".tiny_create_form button").live "click", ->
#		form_container = jQuery(this).parents('.chzn-container').find('.tiny_create_form')
#		# serialize the inputs in tiny create form
#		form_data = form_container.find(':input').serialize()
#		jQuery.ajax '/clients/create',
#			type: 'POST'
#			data:  form_data
#			dataType: 'html'
#			error: (jqXHR, textStatus, errorThrown) ->
#				alert "Error: #{textStatus}"
#			success: (data, textStatus, jqXHR) ->
#				alert data


  applyPopover = (elem,message) ->
    elem.qtip
      content:
        text: message
      show:
        event: false
      hide:
        event: false
      position:
        at: "topRight"
      style:
        tip:
          corner: "leftMiddle"
    elem.qtip().show()
    elem.focus()

  hidePopover = (elem) ->
    elem.qtip("hide")

  jQuery("#client_email").click ->
    hidePopover(jQuery(this))