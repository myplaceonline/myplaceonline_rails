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

// Function may optionally take event and ui parameters:
// http://api.jquerymobile.com/pagecontainer/#event-show
function onPageLoad(func) {
  $(document).one("pagecontainershow", $.mobile.pageContainer, func);
}

function jqmSetListMessage(list, message) {
  list.html("<li>" + message + "</li>");
  list.listview("refresh");
  list.trigger("updatelayout");
}

/* items: [{title: String, link: String, count: Integer}, ...] */
function jqmSetList(list, items, header) {
  var html = "";
  if (header) {
    html += "<li data-role='list-divider'>" + header + "</li>";
  }
  $.each(items, function (i, x) {
    html += "<li><a href='" + x.link + "'>" + x.title + " <span class='ui-li-count'>" + x.count + "</span></a></li>";
  });
  list.html(html);
  list.listview("refresh");
  list.trigger("updatelayout");
}

function navigate(url, skipAjax) {
  if ($.mobile.ajaxEnabled && !skipAjax) {
    $.mobile.pageContainer.pagecontainer("change", url, {
      allowSamePageTransition: true,
      reloadPage: true
    });
  } else {
    window.location = url;
  }
}

function showLoading() {
  $.mobile.loading("show");
}

function hideLoading() {
  $.mobile.loading("hide");
}

$(document).on('ajax:remotipartSubmit', 'form', function() {
  showLoading();
});
