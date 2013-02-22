// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui.js
//= require twitter/bootstrap
//= require jquery.jqplot.js
//= require jqplot.barRenderer.min.js
//= require jqplot.categoryAxisRenderer.min.js
//= require jqplot.pointLabels.min.js
//= require jquery_nested_form
//= require nav.js
//= require chosen.jquery
//= require jquery.css3caching.js
//= require invoice-classes.js.coffee
//= require invoices.js.coffee
//= require formatCurrency.js
//= require tableSorter.js
//= require tablesorter.staticrow.js
//= require jquery.metadata.js
//= require application.js
//= require bootstrap.js.coffee
//= require categories.js.coffee
//= require clients.js.coffee
//= require client_additional_contacts.js.coffee
//= require client_billing_infos.js.coffee
//= require client_contacts.js.coffee
//= require companies.js.coffee
//= require dashboard.js.coffee
//= require invoice_line_items.js.coffee
//= require items.js.coffee
//= require jqamp-ui-spinner.min.js
//= require jquery.qtip.min.js
//= require jwerty.js
//= require payments.js.coffee
//= require payment_terms.js.coffee
//= require recurring_profiles.js.coffee
//= require recurring_profile_line_items.js.coffee
//= require reports.js.coffee
//= require taxes.js.coffee




jQuery(function () {
    //override default behavior of inserting new subforms into form    
    window.NestedFormEvents.prototype.insertFields = function (content, assoc, link) {
        var $tr = $(link).closest('tr');
        return $(content).insertBefore($tr);
    }
    jQuery("#nav .select .sub li").find("a.active").parents("ul.sub").prev("a").addClass("active");
    jQuery("#nav ul.select > li").mouseover(function () {
        jQuery(".sub").hide();
        jQuery(".sub", jQuery(this)).show();
    });
    jQuery("#nav").mouseout(function () {
        jQuery(".sub").hide();
        jQuery("li a.active", jQuery(this)).next(".sub").show();
    });

    // toggle page effect by clicking on alpha tag
    jQuery(".logo_tag").click(function () {
        jQuery("#main-container").toggleClass("page-effect");
    }).qtip();

//    jwerty.key('a,i', function(){document.location.href = document.location.protocol + "//" + document.location.host + "/invoices/new" });
//    jwerty.key('a,c', function(){document.location.href = document.location.protocol + "//" + document.location.host + "/clients/new" });
//    jwerty.key('a,t', function(){document.location.href = document.location.protocol + "//" + document.location.host + "/items/new" });
//    jwerty.key('a,p', function(){document.location.href = document.location.protocol + "//" + document.location.host + "/payments" });
//    jwerty.key('esc', function(){jQuery(document.activeElement).blur();});
});


