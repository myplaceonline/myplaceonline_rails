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
      jqmSetListMessage($ul, "Loading...");
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
  var id = $(obj).attr("id");
  if (id) {
    id = id.replace(/^.+(\d+).+$/i, '$1');
    if (isNaN(id)) {
      id = -1;
    }
    return id;
  }
  return -1;
}

function form_add_item(link, attributesName, attributesPrefix, deletePlaceholder, items) {
  var index = -1;
  var div = $(link).parent().parent(".itemswrapper");
  div.find(".primary_input").each(function() {
    var id = get_index_from_id($(this));
    if (id > index) {
      index = id;
    }
  });
  index++;
  var html = "<div class='itemwrapper'>";
  var toFocus = null;
  var i;
  for (i = 0; i < items.length; i++) {
    var item = items[i];
    var id = attributesName + "_" + attributesPrefix + "_attributes_" + index + "_" + item.name;
    var name = attributesName + "[" + attributesPrefix + "_attributes][" + index + "][" + item.name + "]";
    var cssclasses = '';
    if (item.primary) {
      cssclasses = 'primary_input ';
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
    } else {
      html += "<p><input type='" + item.type + "' id='" + id + "' name='" + name + "' placeholder='" + item.placeholder + "' value='' class='" + cssclasses + "' /></p>";
    }
  }
  html += "<p><a href='#' onclick='return form_remove_item(this);' class='ui-btn'>" + deletePlaceholder + "</a></p>";
  html += "</div>";
  $(html).insertBefore($(link));
  ensureStyledPage();
  if (toFocus) {
    maybeFocus("#" + toFocus);
  }
  return false;
}

function form_remove_item(link) {
  var div = $(link).parent().parent("div");
  var item = div.find(".primary_input").first();
  if (item) {
    var index = get_index_from_id(item);
    if (index != -1) {
      var id = $(item).attr("id");
      var prefix = id.replace(/^(.+)_\d+.+$/i, '$1');
      var prefixFirst = prefix.replace(/^([^_]+)_.+$/i, '$1');
      var prefixRest = prefix.replace(/^[^_]+_(.+)$/i, '$1');
      var destroy_id = prefix + "_" + index + "__destroy";
      var destroy_name = prefixFirst + "[" + prefixRest + "][" + index + "][_destroy]";
      var existing_destroy = $("#" + destroy_id);
      if (existing_destroy.length) {
        existing_destroy.val("1");
      } else {
        var html = "<input type='hidden' id='" + destroy_id + "' name='" + destroy_name + "' value='1' />";
        $(html).insertBefore(item);
      }
      div.hide();
    } else {
      criticalError("Could not find item ID");
    }
  } else {
    criticalError("Error removing item");
  }
  return false;
}