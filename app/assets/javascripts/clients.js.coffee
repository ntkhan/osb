# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
  jQuery ->
    jQuery("#contact").click ->
      jQuery("#adCntcts").toggle 500;
    jQuery("#detail").click ->
      jQuery("#add_Detail").toggle 500;
    jQuery("#submit_form").click ->
      jQuery("#newClient").submit();
