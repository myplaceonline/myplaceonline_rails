$.noty.defaults.timeout = 3000;
$.noty.defaults.layout = 'topCenter';
myp.DEFAULT_DATE_FORMAT = "%A, %b %d, %Y";
myp.DEFAULT_TIME_FORMAT = "%A, %b %d, %Y %-l:%M:%S %p";

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

function get_name_as_id(namePrefix) {
  return namePrefix.replace(/\[/g, '_').replace(/\]/g, '');
}

function form_add_item(link, namePrefix, deletePlaceholder, items, singletonMessage, nonIndexBased) {
  var index = -1;
  var itemswrapper = $(link).parents(".itemswrapper").first();
  if (itemswrapper.length == 0) {
    alert('API error: form_add_item call should be within DIV with class itemswrapper');
  }
  var itemswrapper_id = itemswrapper.attr("id");
  var itemwrappers = itemswrapper.find(".itemwrapper");
  if (!nonIndexBased) {
    itemwrappers.each(function() {
      var id = get_index_from_id($(this));
      if (id > index) {
        index = id;
      }
    });
  }
  index++;
  
  var has_position = false;
  
  //if (singletonMessage && itemwrappers.length > 0) {
  //  alert(singletonMessage);
  //  return false;
  //}
  
  var html = "<div class='itemwrapper " + itemswrapper_id + "' data-nameprefix='" + namePrefix;
  if (!nonIndexBased) {
    html += "[" + index + "]";
  }
  html += "'>";
  var toFocus = null;
  var i;
  var idPrefix = get_name_as_id(namePrefix);
  var futures = [];
  for (i = 0; i < items.length; i++) {
    var item = items[i];
    
    var id = idPrefix;
    if (!nonIndexBased) {
      id += "_" + index + "_" + item.name;
    }
    
    var name = namePrefix;
    if (!nonIndexBased) {
      name += "[" + index + "][" + item.name + "]";
    }
    
    var cssclasses = '';
    if (item.autofocus && !toFocus) {
      toFocus = id;
    }
    if (item.classes) {
      cssclasses += item.classes + ' ';
    }
    
    var defaultValue = "";
    if (item.value) {
      defaultValue = item.value;
    }
    
    if (item.type == "date") {
      // Options should match app/helps/application_helper.rb myp_date_field
      html += "<p><input type='date' id='" + id + "' name='" + name + "' placeholder='" + item.placeholder + "' value='" + defaultValue + "' class='" + cssclasses + "' data-role='datebox' data-datebox-mode='calbox' data-datebox-override-date-format='" + myp.DEFAULT_DATE_FORMAT + "' data-datebox-use-focus='true' data-datebox-use-clear-button='true' data-datebox-use-modal='false' data-datebox-cal-use-pickers='true' data-datebox-cal-year-pick-min='-100' data-datebox-cal-year-pick-max='10' data-datebox-cal-no-header='true' /></p>";
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
    } else if (item.type == "calculation_element") {
      // Duplicated in views/calculation_forms/_element_form.html.erb
      html += html_calculation_operand(item, item.left_heading, id, name, "left_operand_attributes");
      html += "<select id='" + id + "_operator' name='" + name + "[operator]' placeholder='Test'><option value=''>Operator</option><option value='1'>+ (Add)</option><option value='2'>- (Subtract)</option><option value='3'>* (Multiply)</option><option value='4'>/ (Divide)</option></select>";
      html += html_calculation_operand(item, item.right_heading, id, name, "right_operand_attributes");
    } else {
      var inputType = item.type;
      if (item.type == "position") {
        inputType = "hidden";
        has_position = true;
      }
      html += "<p><input type='" + inputType + "' id='" + id + "' name='" + name + "' placeholder='" + item.placeholder + "' value='' class='" + cssclasses + "' /></p>";
    }
  }
  html += "<p><a href='#' onclick='return form_remove_item(this);' class='ui-btn ui-btn-icon-left ui-icon-delete ui-btn-inline'>" + deletePlaceholder + "</a></p>";
  html += "</div>";
  form_add_item_set_html($(link), html, toFocus);
  if (futures.length > 0) {
    showLoading();
  }
  if (has_position) {
    form_set_positions(link);
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

function html_calculation_operand(item, heading, idPrefix, namePrefix, input_name) {
  return '<div data-role="collapsible" data-collapsed="false"><h3>' + heading + '</h3><div data-role="collapsible-set"><div data-role="collapsible" data-collapsed="false"><h3>' + item.constant + '</h3><input type="text" id="' + idPrefix + '_' + input_name + '_constant_value" name="' + namePrefix + '[' + input_name + '][constant_value]" placeholder="' + item.constant_value + '" value="" class="" /></div><div data-role="collapsible" data-collapsed="true"><h3>' + item.sub_element + '</h3><div class="itemswrapper"><p><p><a href="#" onclick="return form_add_item(this, \'' + namePrefix + '[' + input_name + '][calculation_element_attributes]\', \'' + item.delete + '\', [{ type: \'calculation_element\', left_heading: \'' + item.left_heading + '\', right_heading: \'' + item.right_heading + '\', constant_value: \'' + item.constant + '\', sub_element: \'' + item.sub_element + '\', constant: \'' + item.constant_value + '\', create: \'' + item.create + '\', delete: \'' + item.delete + '\', singleton: \'' + item.singleton + '\' }], \'' + item.singleton + '\', true);" class="ui-btn">' + item.create + '</a></p></p></div></div></div></div>';
}

function form_add_item_set_html(insertBefore, html, toFocus) {
  $(html).insertBefore(insertBefore);
  $(insertBefore).parent().trigger('create');
  if (toFocus) {
    maybeFocus("#" + toFocus);
  }
}

function form_remove_item(link) {
  var div = $(link).parents(".itemwrapper").first();
  var namePrefix = div.data("nameprefix");
  var idPrefix = get_name_as_id(namePrefix);
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

function form_move_item(obj, direction) {
  // Find the itemwrapper for our obj
  var itemwrapper = $(obj).parents(".itemwrapper").first();

  if (direction == 1) {
    var search = itemwrapper[0].nextElementSibling;
    while (search) {
      if ($(search).hasClass("itemwrapper")) {
        itemwrapper.remove();
        $(search).after(itemwrapper);
        itemwrapper.trigger('create');
        break;
      }
      search = search.nextElementSibling;
    }
  } else if (direction == -1) {
    var search = itemwrapper[0].previousElementSibling;
    while (search) {
      if ($(search).hasClass("itemwrapper")) {
        itemwrapper.remove();
        $(search).before(itemwrapper);
        itemwrapper.trigger('create');
        break;
      }
      search = search.previousElementSibling;
    }
  }
  
  form_set_positions(obj);
}

function form_get_item_wrappers(obj) {
  var itemswrapper = $(obj).parents(".itemswrapper").first();
  var itemswrapper_id = itemswrapper.attr("id");
  return itemswrapper.find("." + itemswrapper_id);
}

function form_set_positions(obj) {
  var itemswrapper = $(obj).parents(".itemswrapper").first();
  var data_position_field = itemswrapper.data("position-field");
  var itemswrapper_id = itemswrapper.attr("id");
  var itemwrappers = itemswrapper.find("." + itemswrapper_id);
  var position = 1;
  itemwrappers.each(function() {
    var itemwrapper = $(this);
    var itemwrapper_nameprefix = itemwrapper.data("nameprefix");
    var position_id = get_name_as_id(itemwrapper_nameprefix) + "_" + data_position_field;
    $("#" + position_id).val(position);
    position++;
  });
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

function notepad_changed(notepadTitle, pendingSave, saving, saved) {
  $(".notepad_heading").html(notepadTitle + " (" + pendingSave + ")");
  if (myp.notepad && !myp.notepadTimeout) {
    myp.notepadTimeout = window.setTimeout(function() {
      $(".notepad_heading").html(notepadTitle + " (" + saving + ")");
      var url = "/api/updatenotepad.json";
      $.ajax({
        url: url,
        method: "POST",
        dataType: "json",
        data: myp.notepad.getHTML()
      }).done(function(data, textStatus, jqXHR) {
        $(".notepad_heading").html(notepadTitle + " (" + saved + ")");
        window.setTimeout(function() {
          if (!myp.notepadTimeout) {
            $(".notepad_heading").html(notepadTitle);
          }
        }, 3000);
      }).fail(function(jqXHR, textStatus, errorThrown) {
        $(".notepad_heading").html(notepadTitle);
        createErrorNotification("Could not execute " + url + ": " + textStatus);
      }).complete(function(jqXHR, textStatus) {
        myp.notepadTimeout = null;
      });
    }, 1000);
  }
}

function datebox_calendar_closed(update) {
  var timebox = $("#" + this.element.data("datetime-id"));
  timebox.data("calendar-id", this.element.attr("id"));
  timebox.datebox('open');
}

function datebox_timebox_closed(update) {
  var cal = $("#" + this.element.data("calendar-id"));
  var calDate = cal.datebox('getTheDate');
  calDate.setHours(update.date.getHours(), update.date.getMinutes(), update.date.getSeconds(), update.date.getMilliseconds());
  cal.datebox('setTheDate', calDate);
}

function quick_feedback(prompt_text) {
  var result = prompt(prompt_text);
  if (result) {
    var url = "/api/quickfeedback.json";
    $.ajax({
      url: url,
      method: "POST",
      dataType: "json",
      data: result
    }).done(function(data, textStatus, jqXHR) {
      createSuccessNotification("Feedback submitted successfully");
    }).fail(function(jqXHR, textStatus, errorThrown) {
      createErrorNotification("Could not execute " + url + ": " + textStatus);
    }).complete(function(jqXHR, textStatus) {
    });
  }
}
