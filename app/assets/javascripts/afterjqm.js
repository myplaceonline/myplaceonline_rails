// https://github.com/jquery/jquery-mobile/issues/3249
$(document).on("pagecontainerhide.fixcache", $.mobile.pageContainer, function(event, ui) {
  if (ui.prevPage) { // prevPage null on the first request
    $.mobile.firstPage.remove();
    $(document).off('pagecontainerhide.fixcache');
  }
});

// Clicking a link to the page we're already on should reload
$(document).on("pagecontainerbeforechange.settings", $.mobile.pageContainer, function(event, ui) {
  ui.options.reloadPage = true;
  if (ui.prevPage && ui.prevPage.attr && ui.toPage && ui.toPage.attr && ui.prevPage.attr('data-url') == ui.toPage.attr('data-url')) {
    ui.options.transition = "fade";
  }
});

// http://stackoverflow.com/a/24110019/4135310
$(document).on("pagecontainerbeforeshow", $.mobile.pageContainer, function(event, ui) {
  $.mobile.activePage.find('.ui-header a[data-rel=back]').buttonMarkup({iconpos: 'notext'});
});

function jqmSetListMessage(list, message) {
  list.html("<li>" + message + "</li>");
  list.listview("refresh");
  list.trigger("updatelayout");
}

/* items: [{title: String, link: String, count: Integer}, ...] */
function jqmSetList(list, items) {
  var html = "";
  $.each(items, function (i, x) {
    html += "<li><a href='" + x.link + "'>" + x.title + " <span class='ui-li-count'>" + x.count + "</span></a></li>";
  });
  list.html(html);
  list.listview("refresh");
  list.trigger("updatelayout");
}

$(document).on("pageinit", $.mobile.pageContainer, function() {
  $("#myplaceonline_search_list").on("listviewbeforefilter", function(e, data) {
    var $ul = $(this);
    var $input = $(data.input);
    var value = $input.val();
    if (value && value.length > 0) {
      jqmSetListMessage($ul, "Loading...");
      $.ajax({
        url: "/api/categories.json",
        dataType: "json",
        context: $ul
      }).done(function(data, textStatus, jqXHR) {
        jqmSetList(this, $(data));
      }).fail(function(jqXHR, textStatus, errorThrown) {
        jqmSetListMessage($ul, "Error, please try again.");
      });
    }
  });
});
