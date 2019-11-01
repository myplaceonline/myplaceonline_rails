// These includes mimic the includes in the phonegap app. Everything
// else is loaded in application_extra.js.coffee

//= require jquery
//= require jquery.easing
//= require myplaceonline
//= require jquery.mobile
//= require forge.min

$(document).on("change", "select.region", function() {
  var select_wrapper = $(".subregionwrapper");
  $("select", select_wrapper).attr("disabled", true);
  var subregion_code = $(this).val();
  myplaceonline.saveCollapsibleStates();
  var name = $(this).attr("name");
  $.get(
    "/api/subregions?regionstr=" + encodeURIComponent(subregion_code) + "&name=" + encodeURIComponent(name),
    function(data) {
      $(".subregionwrapper").replaceWith(data);
      myplaceonline.ensureStyledPage();
    }
  );
});

$(document).on("change", "select.graph_source", function() {
  var source = $(this).val();
  var id = $(this).attr("id");
  $.get(
    "/graph/source_values?id=" + encodeURIComponent(id) + "&source=" + encodeURIComponent(source),
    function(data) {
      $(".values_container").replaceWith(data);
      $(".xvalues_container").replaceWith(data);
      myplaceonline.ensureStyledPage();
    }
  );
});
