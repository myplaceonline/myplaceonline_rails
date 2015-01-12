$.noty.defaults.timeout = 4000;
$.noty.defaults.layout = 'topCenter';

// https://github.com/rails/jquery-ujs/wiki/ajax
$(document).on('ajax:remotipartSubmit', 'form', function() {
  showLoading();
});

$(document).on('ajax:complete', 'form', function(xhr, status) {
  hideLoading();
});

$(document).on('ajax:error', 'form', function(xhr, status, error) {
  criticalError("Error submitting form: " + getJSON(status) + ", " + getJSON(error));
});

// http://view.jquerymobile.com/master/demos/listview-autocomplete-remote/
function hookListviewSearch(list, url, afterload) {
  list.on("listviewbeforefilter", function(e, data) {
    var $ul = $(this);
    var $input = $(data.input);
    var value = $input.val();
    if (value && value.length > 0 && !$ul[0].allLoaded) {
      jqmSetListMessage($ul, "Searching...");
      $.ajax({
        url: url,
        dataType: "json",
        context: $ul
      }).done(function(data, textStatus, jqXHR) {
        jqmSetList(this, $(data));
        this[0].allLoaded = true;
        if (afterload) {
          afterload(this);
        }
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

function getRemoteString(destination, length) {
  showLoading();
  var url = "/api/randomString";
  if (length) {
    length = parseInt(length);
    if (length > 0) {
      url += "?length=" + length;
    }
  }
  $.ajax({
    url: url,
    dataType: "json",
    context: destination
  }).done(function(data, textStatus, jqXHR) {
    this.val(data.randomString);
  }).fail(function(jqXHR, textStatus, errorThrown) {
    createErrorNotification("Could not execute " + url + ": " + textStatus);
  }).complete(function(jqXHR, textStatus) {
    hideLoading();
  });
}

function get_index_from_id(obj) {
  var id = $(obj).data("nameprefix");
  if (id) {
    id = id.replace(/^.+(\d+).+$/i, '$1');
    if (isNaN(id)) {
      id = -1;
    }
    return id;
  }
  return -1;
}

function isArray(obj) {
  return Object.prototype.toString.call(obj) === '[object Array]';
}

function getIdPrefixFromNamePrefix(namePrefix) {
  return namePrefix.replace(/\[/g, '_').replace(/\]/g, '');
}

function form_add_item(link, namePrefix, deletePlaceholder, items) {
  var index = -1;
  $(link).parents(".itemswrapper").first().find(".itemwrapper").each(function() {
    var id = get_index_from_id($(this));
    if (id > index) {
      index = id;
    }
  });
  index++;
  
  var html = "<div class='itemwrapper' data-nameprefix='" + namePrefix + "[" + index + "]" + "'>";
  var toFocus = null;
  var i;
  var idPrefix = getIdPrefixFromNamePrefix(namePrefix);
  var futures = [];
  for (i = 0; i < items.length; i++) {
    var item = items[i];
    var id = idPrefix + "_" + index + "_" + item.name;
    var name = namePrefix + "[" + index + "][" + item.name + "]";
    var cssclasses = '';
    if (item.autofocus && !toFocus) {
      toFocus = id;
    }
    if (item.classes) {
      cssclasses += item.classes + ' ';
    }
    if (item.type == "date") {
      // Options should match app/helps/application_helper.rb myp_date_field
      html += "<p><input type='date' id='" + id + "' name='" + name + "' placeholder='" + item.placeholder + "' value='' class='" + cssclasses + "' data-role='datebox' data-datebox-mode='datebox' data-datebox-override-date-format='%Y-%m-%d' data-datebox-use-focus='true' data-datebox-use-clear-button='true' /></p>";
    } else if (item.type == "random") {
      // Duplicated in views/myplaceonline/_generaterandom.html.erb
      html += '<div data-role="collapsible"><h3>' + item.heading + '</h3><p><input type="number" class="generate_password_length" value="" placeholder="' + item.lengthplaceholder + '" /></p><p><a href="#" class="ui-btn" onclick="getRemoteString(' + item.destination + ', $(this).parents(\'div\').first().find(\'.generate_password_length\').val()); return false;">' + item.button + '</a></p></div>';
    } else if (item.type == "textarea") {
      html += "<p><textarea id='" + id + "' name='" + name + "' placeholder='" + item.placeholder + "' value='' class='" + cssclasses + "'></textarea></p>";
    } else if (item.type == "renderpartial") {
      item.namePrefix = name;
      item.id = "remote_placeholder_" + id;
      html += "<p id='" + item.id + "'>Loading...</p>";
      futures.push(item);
    } else {
      html += "<p><input type='" + item.type + "' id='" + id + "' name='" + name + "' placeholder='" + item.placeholder + "' value='' class='" + cssclasses + "' /></p>";
    }
  }
  html += "<p><a href='#' onclick='return form_remove_item(this);' class='ui-btn'>" + deletePlaceholder + "</a></p>";
  html += "</div>";
  form_add_item_set_html($(link), html, toFocus);
  if (futures.length > 0) {
    showLoading();
  }
  for (i = 0; i < futures.length; i++) {
    var item = futures[i];
    var url = "/api/renderpartial.json";
    $.ajax({
      url: url,
      dataType: "json",
      contentType: "application/json",
      type: "POST",
      data: JSON.stringify(item),
      context: item
    }).done(function(data, textStatus, jqXHR) {
      if (data.success) {
        $("#" + this.id).html(data.html);
      } else {
        $("#" + this.id).html("<b>Error:</b> " + data.error);
      }
      ensureStyledPage();
      // Fire off any onPageLoad events
      $.mobile.pageContainer.trigger("pagecontainershow");
    }).fail(function(jqXHR, textStatus, errorThrown) {
      createErrorNotification("Could not execute " + url + ": " + textStatus);
    }).complete(function(jqXHR, textStatus) {
      hideLoading();
    });
  }
  return false;
}

function form_add_item_set_html(insertBefore, html, toFocus) {
  $(html).insertBefore(insertBefore);
  ensureStyledPage();
  if (toFocus) {
    maybeFocus("#" + toFocus);
  }
}

function form_remove_item(link) {
  var div = $(link).parents(".itemwrapper").first();
  var namePrefix = div.data("nameprefix");
  var idPrefix = getIdPrefixFromNamePrefix(namePrefix);
  var destroy_id = idPrefix + "__destroy";
  var destroy_name = namePrefix + "[_destroy]";
  var existing_destroy = $("#" + destroy_id);
  if (existing_destroy.length) {
    existing_destroy.val("1");
  } else {
    var html = "<input type='hidden' id='" + destroy_id + "' name='" + destroy_name + "' value='1' />";
    $(html).insertBefore(div);
  }
  div.hide();
  return false;
}

function object_extract_id(obj) {
  return href_extract_id($(obj).attr("href"));
}

function href_extract_id(href) {
  var x = href.lastIndexOf("/"); 
  if (x != -1) {
    href = href.substring(x + 1);
  }
  return href;
}