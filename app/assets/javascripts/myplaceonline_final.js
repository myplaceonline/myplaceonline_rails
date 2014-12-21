$.noty.defaults.timeout = 4000;
$.noty.defaults.layout = 'topCenter';

$(document).on('ajax:remotipartSubmit', 'form', function() {
  showLoading();
});

// http://view.jquerymobile.com/master/demos/listview-autocomplete-remote/
function hookListviewSearch(list, url) {
  list.on("listviewbeforefilter", function(e, data) {
    var $ul = $(this);
    var $input = $(data.input);
    var value = $input.val();
    if (value && value.length > 0 && !$ul[0].allLoaded) {
      jqmSetListMessage($ul, "Loading...");
      $.ajax({
        url: url,
        dataType: "json",
        context: $ul
      }).done(function(data, textStatus, jqXHR) {
        jqmSetList(this, $(data));
        this[0].allLoaded = true;
      }).fail(function(jqXHR, textStatus, errorThrown) {
        jqmSetListMessage(this, "Error, please try again.");
      });
    }
  });
}

function hookListviewEnter(listInput, listIdentifier) {
  listInput.keyup(function(e) {
    if (e.which == 13) {
      var searchList = $(listIdentifier + " li:not(.ui-screen-hidden)");
      if (searchList.size() > 0) {
        e.preventDefault();
        navigate(searchList.filter(":first").children("a").attr("href"));
      }
    }
    return true;
  });
}
