# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
    # Validate client
  jQuery("form#new_item, form.edit_item").submit ->
    flag = true
    if jQuery.trim(jQuery("#item_item_name").val()) is ""
      applyPopover(jQuery("#item_item_name"),"top","Item name is required")
      flag = false
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

  jQuery("#item_item_name").click ->
    hidePopover(jQuery(this))