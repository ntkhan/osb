# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  jQuery(".chzn-select").chosen({allow_single_deselect: true})
  jQuery("#contact").click ->
    jQuery("#adCntcts").toggle 500;
  jQuery("#detail").click ->
    jQuery("#add_Detail").toggle 500;
  jQuery("#submit_form").click ->
    jQuery("#newClient").submit();

  # Validate client
  jQuery("form#newClient").submit ->
    flag = true
    pattern = /^\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b$/i
    client_email = jQuery("#client_email").val()
    if client_email is ""
      applyPopover(jQuery("#client_email"),"top","Email is required")
      flag = false
    else unless pattern.test(client_email)
      applyPopover(jQuery("#client_email"),"top","Invalid email")
      flag = false
    else if jQuery("#client_organization_name").val() is ""
      jQuery("#client_organization_name").val(client_email)
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

  jQuery("#client_email").click ->
    hidePopover(jQuery(this))