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

function createSuccessNotification(message, timeout) {
  if (!timeout) {
    timeout = $.noty.defaults.timeout;
  }
  noty({text: message, layout: $.noty.defaults.layout, type: 'success', timeout: timeout});
}

function createErrorNotification(message, duration, timeout) {
  if (!timeout) {
    timeout = $.noty.defaults.timeout;
  }
  noty({text: message, layout: $.noty.defaults.layout, type: 'error', timeout: timeout});
}

function ensureClipboard(objects) {
  var clipboard = new ZeroClipboard(objects);
  clipboard.on( "ready", function(readyEvent) {
    clipboard.on( "aftercopy", function(event) {
      createSuccessNotification("Copied to clipboard.");
    });
  });
}

function jqmSetListMessage(list, message) {
  list.html("<li data-role=\"visible\">" + message + "</li>");
  list.listview("refresh");
  list.trigger("updatelayout");
}

// Override the default filterCallback to always show list items with
// data-role="visible" in addition to the default behavior
$.mobile.filterable.prototype.options.filterCallback = function (index, searchValue) {
  if ($.mobile.getAttribute( this, "role" ) == "visible") {
    return false;
  }
  searchValue = searchValue.toLowerCase();
  return ( ( "" + ( $.mobile.getAttribute( this, "filtertext" ) || $( this ).text() ) ).toLowerCase().indexOf( searchValue ) === -1 );
}

/* items: [{title: String, link: String, count: Integer}, ...] */
function jqmSetList(list, items, header) {
  var html = "";
  if (header) {
    html += "<li data-role='list-divider'>" + header + "</li>";
  }
  $.each(items, function (i, x) {
    if (x.count) {
      html += "<li><a href='" + x.link + "'>" + x.title + " <span class='ui-li-count'>" + x.count + "</span></a></li>";
    } else {
      html += "<li><a href='" + x.link + "'>" + x.title + "</a></li>";
    }
  });
  list.html(html);
  list.listview("refresh");
  list.trigger("updatelayout");
}

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
