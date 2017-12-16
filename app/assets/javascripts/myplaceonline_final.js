// myplaceonline_final.js
//   The separation between myplaceonline.js and myplaceonline_final.js is 
//   because we have to ship core functions for PhoneGap initialization
//   (myplaceonline.js), after which myplaceonline_final.js is loaded remotely.
//   Code added to myplaceonline_final.js will be picked up dynamically, whereas
//   updates to myplaceonline.js must be updated and shipped in a new version
//   of the mobile app.
//
// =============================================================================
//
// Use the loose augmentation module pattern [1]. Variables and functions should
// be defined as locally-scoped and only explicitly exported [2] if part of the
// public API through property assignment at the end of the module function.
//
// [1] http://www.adequatelygood.com/JavaScript-Module-Pattern-In-Depth.html
// [2] http://www.w3.org/wiki/JavaScript_best_practices#Avoid_globals

var myplaceonline = function(mymodule) {
  
  var DEFAULT_DATE_FORMAT = "%A, %b %d, %Y";
  var DEFAULT_TIME_FORMAT = "%A, %b %d, %Y %-l:%M:%S %p";
  var JQM_DATEBOX_TIMEBOX_FORMAT = "%I:%M %p"

  var queuedRequests = [];
  var queuedRequestThread = null;
  var notepadResetTimeout = null;
  var debugsSent = 0;
  
  $.noty.defaults.timeout = 3000;
  $.noty.defaults.layout = 'topCenter';
  
  $.ajaxPrefilter(function(options, originalOptions, xhr) {
    // "For AJAX requests other than GETs, extract the “csrf-token” from the
    // meta-tag and send as the “X-CSRF-Token” HTTP header."
    // http://api.rubyonrails.org/classes/ActionView/Helpers/CsrfHelper.html
    // http://stackoverflow.com/questions/7203304
    xhr.setRequestHeader("X-CSRF-Token", $("meta[name='csrf-token']").attr("content"));
  });

  // https://github.com/rails/jquery-ujs/wiki/ajax
  $(document).on("ajax:remotipartSubmit", "form", function() {
    myplaceonline.consoleLog("ajax:remotipartSubmit: Submitting " + this.action + " ...");
    myplaceonline.showLoading();
  });

  $(document).on("ajax:complete", "form", function(xhr, status) {
    
    myplaceonline.hideLoading();
    
    var contentType = status.getResponseHeader("Content-Type");
    
    myplaceonline.consoleLog("ajax:complete Content-Type: " + contentType);
    
    myplaceonline.consoleLog("ajax:complete xhr: " + xhr);
    myplaceonline.consoleDir(xhr);
    myplaceonline.consoleLog("ajax:complete status: " + status);
    myplaceonline.consoleDir(status);
    
    // https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/getAllResponseHeaders
    var responseHeaders = status.getAllResponseHeaders();
    if (responseHeaders) {
      myplaceonline.consoleLog("ajax:complete response headers: " + responseHeaders);
    } else {
      myplaceonline.consoleLog("ajax:complete response headers blank!");
    }

    if (!contentType) {
      if (status.status == 200) {
        myplaceonline.criticalError("Submission succeeded but we failed to process the result. Refreshing the page...");
        myplaceonline.refreshWithParam();
      } else {
        myplaceonline.criticalError("Error (" + status.status + "): " + status.responseText);
      }
    } else if (myplaceonline.startsWith(contentType, "text/html")) {
      // We expect a "successful" submission will return text/javascript
      // which will do something like navigate to the success page
      // (see MyplaceonlineController.may_upload). If it's text/html,
      // then there was probably some error, so we need to display it.
      myplaceonline.showLoading();
      
      var html = $(status.responseText);
      var content = html.find(".ui-content");
      $(".ui-content").replaceWith(content);
      
      myplaceonline.ensureStyledPage();
      myplaceonline.hideLoading();
      myplaceonline.scrollTop();
      
      // Since this was an error, we need to re-run any onPageLoad functions
      if (myplaceonline.runPendingPageLoads) {
        myplaceonline.runPendingPageLoads();
      }
    } else {
      // Successful
    }
  });

  $(document).on("ajax:error", "form", function(xhr, status, error) {
    if (status && status.statusText == "timeout") {
      alert("The request timed out. Please check your internet connection and try again.");
    }
    myplaceonline.criticalError("Error submitting form: status: " + myplaceonline.getJSON(status) + ", error: " + myplaceonline.getJSON(error));
  });

  $(document).on("click", "#mainbutton", function(eventData) {
    if (eventData && eventData.shiftKey) {
      try {
        $("#mainButtonPopup").popup("open");
        myplaceonline.maybeFocus("#mainButtonPopup_search_container input");
      } catch (e) {
        // Error: cannot call methods on popup prior to initialization; attempted to call method 'open'
        alert("The page didn't load yet. Please try again.");
      }
      return false;
    } else if (eventData && eventData.ctrlKey) {
      myplaceonline.navigate("/");
      return false;
    } else {
      return true;
    }
  });
  
  $(document).on("change", ":file", function() {
    var $this = $(this);
    if (this.files && this.files.length > 0) {
      if ($this.data("useprogress")) {
        
        myplaceonline.prepareUploadFiles($this, this.files.length);
        
        var i = 0;
        for (i = 0; i < this.files.length; i++) {
          var file = this.files[i];
          myplaceonline.uploadFile(file, $this);
        }
      }
    }
  });
  
  function jqmSetListMessage(list, message) {
    list.html("<li data-role=\"visible\">" + message + "</li>");
    list.listview("refresh");
    list.trigger("updatelayout");
  }
  
  /* items: [{title: String, link: String, count: Integer, filtertext: String, icon: String, splitLink: String, splitLinkTitle: String}, ...] */
  function jqmSetList(list, items, header, itemsOffset, itemsPerPage) {
    var html = "";
    if (header) {
      html += "<li data-role='list-divider'>" + header + "</li>";
    }

    if (!itemsOffset) {
      itemsOffset = 0;
    }
    if (!itemsPerPage) {
      itemsPerPage = list.data("items-per-page");
      if (!itemsPerPage || itemsPerPage == "") {
        itemsPerPage = 1000;
      }
    }
    
    myplaceonline.consoleLog("jqmSetList: updating list items");
    myplaceonline.consoleDir(items);
    
    var itemsMaxBounds = itemsOffset + itemsPerPage;
    var i;
    for (i = itemsOffset; i < items.length && i < itemsMaxBounds; i++) {
      var x = items[i];
      var filtertext = x.title;
      if (x.filtertext) {
        filtertext = x.filtertext;
      }
      html += "<li data-filtertext='" + myplaceonline.encodeEntities(filtertext) + "'";
      if (x.forcevisible) {
        html += " data-forcevisible='true'";
      }
      if (x.divider) {
        html += " data-role='list-divider'";
      }
      html += ">";
      if (x.link) {
        html += "<a href='" + x.link + "'>";
      }
      if (x.icon) {
        html += "<img alt='" + myplaceonline.encodeEntities(x.title) + "' title='" + myplaceonline.encodeEntities(x.title) + "' class='ui-li-icon' height='16' width='16' src='" + x.icon + "' />";
      }
      if (x.count) {
        html += " <span class='ui-li-count'>" + x.count + "</span>";
      }
      if (x.is_html) {
        html += x.title;
      } else {
        html += myplaceonline.encodeEntities(x.title);
      }
      if (x.link) {
        html += "</a>";
      }
      if (x.splitLink) {
        html += "<a href='" + x.splitLink + "' class='splitlink'";
        if (x.splitLinkButton) {
          html += " data-icon='" + x.splitLinkButton + "'";
        }
        html += ">" + myplaceonline.encodeEntities(x.splitLinkTitle) + "</a>";
      }
      html += "</li>";
    };
    
    if (i < items.length || itemsOffset > 0) {
      html += "<li style='text-align: center;' data-forcevisible='true'>";
      html += "Items " + (itemsOffset + 1) + " - " + (itemsOffset + itemsPerPage) + " of " + items.length + ". <span>";
      
      var hasNext = (i < items.length);
      
      if (itemsOffset > 0) {
        html += "<a href='#' onclick='myplaceonline.jqmListPrevious(this); return false;'>Previous " + itemsPerPage + "</a>";
        if (hasNext) {
          html += " | ";
        }
      }
      
      if (hasNext) {
        html += "<a href='#' onclick='myplaceonline.jqmListNext(this); return false;'>Next " + itemsPerPage + "</a>";
      }
      
      html += "</span></li>";
    }
    
    //myplaceonline.consoleLog("Updating HTML: " + html);
    list.html(html);
    list.listview("refresh");
    list.trigger("updatelayout");
    
    // Store the actual data also
    list.data("rawItems", items);
    list.data("header", header);
    list.data("itemsOffset", itemsOffset);
    list.data("itemsPerPage", itemsPerPage);
  }
  
  function jqmListNext(obj) {
    var $ul = $(obj).parents("ul").first();
    var itemsOffset = $ul.data("itemsOffset");
    var itemsPerPage = $ul.data("itemsPerPage");
    var rawItems = $ul.data("rawItems");
    var header = $ul.data("header");
    
    itemsOffset += itemsPerPage;
    
    myplaceonline.jqmSetList($ul, rawItems, header, itemsOffset, itemsPerPage);
    jqmRunAfterLoad($ul);
  }

  function jqmListPrevious(obj) {
    var $ul = $(obj).parents("ul").first();
    var itemsOffset = $ul.data("itemsOffset");
    var itemsPerPage = $ul.data("itemsPerPage");
    var rawItems = $ul.data("rawItems");
    var header = $ul.data("header");
    
    itemsOffset -= itemsPerPage;
    
    myplaceonline.jqmSetList($ul, rawItems, header, itemsOffset, itemsPerPage);
    jqmRunAfterLoad($ul);
  }
  
  function jqmRunAfterLoad($list) {
    if ($list.data("afterload")) {
      $list.data("afterload")($list);
    }
  }

  function jqmReplaceListSection(list, sectionTitle, items) {
    var existingItems = list.data("rawItems");
    var result = [];
    var i;
    var state = 0;
    
    myplaceonline.consoleLog("jqmReplaceListSection sectionTitle: " + sectionTitle + ", items count: " + (items ? items.length : 0));
    
    if (existingItems) {
      for (i = 0; i < existingItems.length; i++) {
        var existingItem = existingItems[i];
        if (existingItem.divider) {
          
          // Always add the dividers to the result
          result.push(existingItem);
          
          // If the title of the divider is equal to the incoming
          // section name, then start the state machine (state = 1)
          // so that we don't add any items in this section to the result
          // (since those will be added with the incoming `items` array).
          // Otherwise, reset the state machine, so that subsequent
          // existing items in other sections are added
          if (existingItem.title == sectionTitle) {
            state = 1;
            
            // Append the incoming overriden items on to this section
            Array.prototype.push.apply(result, items);
          } else {
            state = 0;
          }
        } else if (state == 0) {
          result.push(existingItem);
        }
      }
      jqmSetList(list, result);
    }
  }

  function jqmSectionHasMatch(list, sectionTitle, search) {
    var result = false;
    var existingItems = list.data("rawItems");
    var i;
    var state = 0;
    if (existingItems && search) {
      var searchLower = search.toLowerCase();
      for (i = 0; i < existingItems.length; i++) {
        var existingItem = existingItems[i];
        if (existingItem.divider) {
          if (existingItem.title == sectionTitle) {
            state = 1;
          } else {
            state = 0;
          }
        } else if (state == 1) {
          if (!existingItem.fake && (existingItem.title.toLowerCase().indexOf(searchLower) != -1 || (existingItem.filtertext && existingItem.filtertext.toLowerCase().indexOf(searchLower) != -1))) {
            result = true;
            break;
          }
        }
      }
    }
    return result;
  }
  
  // http://view.jquerymobile.com/master/demos/listview-autocomplete-remote/
  function hookListviewSearch(list, url, afterload) {
    list.on("listviewbeforefilter", function(e, data) {
      var $ul = $(this);
      var $input = $(data.input);
      var value = $input.val();
      if (value && value.length > 0) {
        listviewSearch($ul, url, value, afterload);
      }
    });
  }
  
  function listviewSearch(list, url, value, afterload) {
    if (!list[0].allLoaded) {
      myplaceonline.jqmSetListMessage(list, "Searching...");
      var data = {
        value: value
      };
      $.ajax({
        url: url,
        dataType: "json",
        context: list,
        data: data
      }).done(function(data, textStatus, jqXHR) {
        myplaceonline.jqmSetList(this, $(data));
        this[0].allLoaded = true;
        if (afterload) {
          afterload(this);
        }
      }).fail(function(jqXHR, textStatus, errorThrown) {
        myplaceonline.jqmSetListMessage(this, "Error, please try again.");
      });
    }
  }

  function hookListviewEnter(listInput, listIdentifier) {
    listInput.keyup(function(e) {
      if (e.which == 13) {
        // If there's no input and we're on the homepage, then don't navigate, because
        // most likely the user was pressing enter on something else in the browser UI
        // and we really shouldn't even be handling it
        var url = window.location.pathname + window.location.search;
        if (this.value.length > 0 || url != "/") {
          var searchList = $(listIdentifier + " li:not(.ui-screen-hidden)").filter(":not(.ui-li-divider)");
          if (searchList.size() > 0) {
            var child = searchList.filter(":first");
            if (child.length) {
              var childLink = child.children("a:first");
              if (childLink.length) {
                var childLinkHref = childLink.attr("href");
                if (childLinkHref && childLinkHref.length > 0) {
                  e.preventDefault();
                  myplaceonline.navigate(childLinkHref);
                  return false;
                }
              }
            }
          }
        }
      }
      return true;
    });
  }
  
  function listLoadComplete($list, context, items, query) {
    jqmReplaceListSection($list, context.title, items);
    context.failed = false;
    jqmRunAfterLoad($list);
    
    if (context.noresults && !jqmSectionHasMatch($list, context.title, query)) {
      context.noresults($list, context, context.title, query);
    }
  }
  
  function remoteDataLoad(remote, value, list) {
    var requestData = {
      q: value
    };
    // Try to abort any previous AJAX calls
    var pending_requests = list.data("pending_ajax_requests" + remote.uniqueid);
    if (pending_requests) {
      for (var i = 0; i < pending_requests.length; i++) {
        var pending_request = pending_requests[i];
        try {
          myplaceonline.consoleLog("remoteDataLoad trying to abort AJAX request");
          pending_request.abort();
        } catch (e) {
          myplaceonline.consoleLog("remoteDataLoad caught error aborting AJAX request " + e);
        }
      }
      list.data("pending_ajax_requests" + remote.uniqueid, []);
    }
    
    var jqxhr = $.ajax({
      url: remote.url,
      dataType: "json",
      context: {list: list, remote: remote, filterCount: remote.filterCount, q: value},
      data: requestData
    }).done(function(data, textStatus, jqXHR) {
      myplaceonline.consoleLog("remoteDataLoad done for " + this.q + "; " + this.remote.title + ", " + this.remote.filterCount + ", " + this.filterCount);
      var pending_requests = this.list.data("pending_ajax_requests" + this.remote.uniqueid);
      if (pending_requests) {
        var new_pending_requests = [];
        var found = false;
        for (var i = 0; i < pending_requests.length; i++) {
          var pending_request = pending_requests[i];  
          if (jqXHR == pending_request) {
            found = true;
            myplaceonline.consoleLog("remoteDataLoad found AJAX object, removing");
            break;
          } else {
            new_pending_requests.push(pending_request);
          }
        }
        if (found) {
          this.list.data("pending_ajax_requests" + this.remote.uniqueid, new_pending_requests);
        }
      }
      if (this.remote.static_list || this.filterCount == this.remote.filterCount) {
        
        myplaceonline.consoleLog("remoteDataLoad filterCount is the latest, result length = " + data.length);
        
        myplaceonline.consoleDir(data);
        
        listLoadComplete(this.list, this.remote, data, this.q);

      } else {
        myplaceonline.consoleLog("remoteDataLoad filterCount is not the latest, skipping");
      }
      myplaceonline.consoleLog("remoteDataLoad finished done");
    }).fail(function(jqXHR, textStatus, errorThrown) {
      if (textStatus != "abort") {
        this.remote.failed = true;
        var errorMessage = "Error performing search. Please try again and check your internet connection.";
        myplaceonline.createErrorNotification(errorMessage);
        jqmReplaceListSection(this.list, this.remote.title, [{ title: errorMessage }]);
        myplaceonline.criticalError(errorMessage + " to remote " + this.remote.title + ", query " + this.q + ", jqXHR: " + jqXHR.readyState + ", " + jqXHR.status + ", " + jqXHR.responseText + ", " + jqXHR.responseXML + ", status: " + textStatus, errorThrown);
      }
    });
    
    // Remember this AJAX request in case we want to abort it
    pending_requests = list.data("pending_ajax_requests" + remote.uniqueid);
    if (!pending_requests) {
      pending_requests = [];
    }
    pending_requests.push(jqxhr);
    list.data("pending_ajax_requests" + remote.uniqueid, pending_requests);
  }
  
  function remoteDataListReset(list, skipListReset) {
    myplaceonline.consoleLog("remoteDataList Resetting");

    if (!skipListReset) {
      list.html(list.data("originalItems"));

      jqmRunAfterLoad(list);
    }
    
    myplaceonline.consoleLog("remoteDataList setting hasInitialized");
    
    list.data("hasInitialized", false);
  }
  
  // http://demos.jquerymobile.com/1.4.5/filterable/
  function remoteDataListInitialize(list, remotes, afterload, noresults) {
    
    for (var i = 0; i < remotes.length; i++) {
      remotes[i].uniqueid = i;
    }
    list.data("remotes", remotes);
    list.data("afterload", afterload);
    
    // Call afterload for any existing items
    if (afterload) {
      afterload(list);
    }
    
    // This is called every time the filter changes
    list.on("filterablebeforefilter", function(e, data) {
      
      // Call preventDefault to stop the subsequent filtering logic from executing
      // e.preventDefault();
      
      var $ul = $(this);
      
      if (!$ul.data("originalItems")) {
        // If this is the first filter, then save off the original items
        // in case we ever want to revert back
        $ul.data("originalItems", $ul.html());
      }
      
      var $input = $(data.input);
      var value = $input.val();
      if (!value) {
        value = "";
      }
      
      var previousSearch = $ul.data("previousSearch");

      var i;
      var remotesList = $ul.data("remotes");
      for (i = 0; i < remotesList.length; i++) {
        var remote = remotesList[i];
        var filterCount = remote.filterCount;
        if (!filterCount) {
          filterCount = 0;
        }
        filterCount++;
        remote.filterCount = filterCount;
        myplaceonline.consoleLog("remoteDataList search " + value + " (previous: " + previousSearch + "), remote " + remote.title + ", search # " + filterCount);
      }
        
      $ul.data("previousSearch", value);
      
      if (previousSearch == value) {
        
        myplaceonline.consoleLog("remoteDataList returning without action");
        
        return;
      }
      
      if (value.length > 0) {
        
        // Clear out the original list on the first search
        if (!$ul.data("hasInitialized")) {
          
          myplaceonline.consoleLog("remoteDataList performing initial search");

          // Create the categories and an item showing search status
          var searching = new Array(remotesList.length * 2);
          for (i = 0; i < remotesList.length; i++) {
            var remote = remotesList[i];
            searching[i*2] = {title: remote.title, forcevisible: true, divider: true};
            searching[(i*2)+1] = {title: "Searching...", filtertext: value, fake: true};
          }
          myplaceonline.jqmSetList($ul, searching);
          
          // Do the actual searches
          for (i = 0; i < remotesList.length; i++) {
            var remote = remotesList[i];
            
            if (remote.preloaded_list) {
              listLoadComplete($ul, remote, remote.preloaded_list, value);
            } else {
              myplaceonline.consoleLog("remoteDataLoad started " + remote.title);

              remoteDataLoad(remote, value, $ul);

              myplaceonline.consoleLog("remoteDataLoad returned for " + remote.title);
            }
          }

          myplaceonline.consoleLog("remoteDataList setting initialized");
          
          $ul.data("hasInitialized", true);
        } else {
          
          myplaceonline.consoleLog("remoteDataList Refreshing dynamic categories if needed");
          
          for (i = 0; i < remotesList.length; i++) {
            var remote = remotesList[i];
            
            if (!remote.static_list || remote.failed) {

              myplaceonline.consoleLog("remoteDataList Re-searching " + remote.title);

              jqmReplaceListSection($ul, remote.title, [{title: "Searching...", filtertext: value, fake: true}]);

              remoteDataLoad(remote, value, $ul);
            } else if (remote.static_list) {
              if (remote.noresults && !jqmSectionHasMatch($ul, remote.title, value)) {
                remote.noresults($ul, remote, remote.title, value);
              }
            }
            
            myplaceonline.consoleLog("remoteDataList Finished processing " + remote.title);
          }

          myplaceonline.consoleLog("remoteDataList finished non static searches");
        }
      } else {
        remoteDataListReset($ul);
      }
    });
  }

  function getRemoteString(destination, length, options) {
    myplaceonline.showLoading();
    var url = "/api/randomString";
    if (length) {
      length = parseInt(length);
      if (length > 0) {
        url += url.indexOf('?') == -1 ? "?" : "&";
        url += "length=" + encodeURIComponent(length);
      }
    }
    if (options && options.length) {
      options.each(function(i, el) {
        url += url.indexOf('?') == -1 ? "?" : "&";
        url += el.id + "=" + el.checked;
      });
    }
    $.ajax({
      url: url,
      dataType: "json",
      context: destination
    }).done(function(data, textStatus, jqXHR) {
      if (data.success) {
        this.val(data.randomString);
      } else {
        myplaceonline.createErrorNotification(data.details);
      }
    }).fail(function(jqXHR, textStatus, errorThrown) {
      myplaceonline.createErrorNotification("Could not execute " + url + ": " + textStatus);
    }).complete(function(jqXHR, textStatus) {
      myplaceonline.hideLoading();
    });
  }

  function get_index_from_id(obj) {
    var id = $(obj).data("nameprefix");
    if (id) {
      id = id.substring(id.lastIndexOf('[') + 1);
      id = id.substring(0, id.indexOf(']'));
      id = parseInt(id);
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
  
  function randomString(length) {
    var text = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for(var i = 0; i < length; i++) {
      text += possible.charAt(Math.floor(Math.random() * possible.length));
    }

    return text;
  }

  function formAddItem(link, namePrefix, deletePlaceholder, items, singletonMessage, nonIndexBased) {
    var index = -1;
    var itemswrapper = $(link).parents(".itemswrapper").first();
    if (itemswrapper.length == 0) {
      alert('API error: formAddItem call should be within DIV with class itemswrapper');
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
    var onlyShow = itemswrapper.data("onlyshow");
    if (!onlyShow) {
      onlyShow = "";
    }
    var toFocus = null;
    var i;
    var idPrefix = get_name_as_id(namePrefix);
    var futures = [];
    for (i = 0; i < items.length; i++) {
      var item = items[i];
      var itemNamePieces = null;
      if (item.name) {
        itemNamePieces = item.name.split('.');
      } else {
        itemNamePieces = new Array();
      }

      var finalNamePiece = "";
      if (itemNamePieces.length > 0) {
        finalNamePiece = itemNamePieces[itemNamePieces.length - 1];
      }
      
      var id = idPrefix;
      if (!nonIndexBased) {
        id += "_" + index;
        for (var j = 0; j < itemNamePieces.length; j++) {
          id += "_" + itemNamePieces[j];
        }
      }
      
      var name = namePrefix;
      if (!nonIndexBased) {
        name += "[" + index + "]";
        for (var j = 0; j < itemNamePieces.length; j++) {
          name += "[" + itemNamePieces[j] + "]";
        }
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
      
      defaultValue = defaultValue.replace(/'/g, '').replace(/"/g, '');
      
      if (item.value && item.value.length > 0 && item.placeholder && item.placeholder.length > 0) {
        html += "<b>" + myplaceonline.encodeEntities(item.placeholder) + "</b><br />";
      }
      
      if (item.type == "date" || item.type == "datetime") {
        // Options should match app/helps/application_helper.rb myp_date_field
        
        if (onlyShow.length > 0 && onlyShow != finalNamePiece) {
          html += "<div style='display: none'>";
        }
        
        var random_name = "";
        html += "<p>"
        if (item.type == "datetime") {
          random_name = randomString(10);
          html += "<input type='hidden' id='" + random_name + "' name='" + random_name + "' placeholder='" + item.placeholder + "' value='" + item.timeboxValue + "' data-role='datebox' data-datebox-mode='timebox' data-datebox-override-date-format='" + JQM_DATEBOX_TIMEBOX_FORMAT + "' data-datebox-use-focus='true' data-datebox-use-modal='false' data-datebox-use-button='false' data-datebox-popup-position='window' data-datebox-close-callback='dateboxTimeboxClosed' />";
        }
        html += "<input type='" + (myplaceonline.isFocusAllowed() ? "text" : "text") + "' id='" + id + "' name='" + name + "' placeholder='" + item.placeholder + "' value='" + defaultValue + "' class='" + cssclasses + "' data-role='datebox' data-datebox-mode='calbox' data-datebox-override-date-format='" + (item.type == "datetime" ? DEFAULT_TIME_FORMAT : DEFAULT_DATE_FORMAT) + "' data-datebox-use-focus='true' data-datebox-use-clear-button='true' data-datebox-use-modal='false' data-datebox-cal-use-pickers='true' data-datebox-cal-year-pick-min='-100' data-datebox-cal-year-pick-max='10' data-datebox-cal-no-header='true' data-datebox-close-callback='" + (item.type == "datetime" ? "dateboxCalendarClosed" : "false") + "' data-datetime-id='" + random_name + "' />";
        html += "</p>";

        if (onlyShow.length > 0 && onlyShow != finalNamePiece) {
          html += "</div>";
        }
      } else if (item.type == "random") {
        if (onlyShow.length > 0 && onlyShow != finalNamePiece) {
          html += "<div style='display: none'>";
        }
        
        // Duplicated in views/myplaceonline/_generaterandom.html.erb
        html += '<div data-role="collapsible"><h3>' + item.heading + '</h3><p><input type="' + (myplaceonline.isFocusAllowed() ? "number" : "text") + '" class="generate_password_length" value="" placeholder="' + item.lengthplaceholder + '" /></p><p><a href="#" class="ui-btn" onclick="myplaceonline.getRemoteString(' + item.destination + ', $(this).parents(\'div\').first().find(\'.generate_password_length\').val()); return false;">' + item.button + '</a></p></div>';

        if (onlyShow.length > 0 && onlyShow != finalNamePiece) {
          html += "</div>";
        }
      } else if (item.type == "textarea") {
        if (onlyShow.length > 0 && onlyShow != finalNamePiece) {
          html += "<div style='display: none'>";
        }
        
        html += "<p><textarea id='" + id + "' name='" + name + "' placeholder='" + item.placeholder + "' class='" + cssclasses + "'></textarea></p>";

        if (onlyShow.length > 0 && onlyShow != finalNamePiece) {
          html += "</div>";
        }
      } else if (item.type == "checkbox") {
        if (onlyShow.length > 0 && onlyShow != finalNamePiece) {
          html += "<div style='display: none'>";
        }
        
        html += "<p><label for='" + id + "'>" + item.placeholder + "</label><input type='checkbox' id='" + id + "' name='" + name + "' class='" + cssclasses + "' value='1' /></p>";

        if (onlyShow.length > 0 && onlyShow != finalNamePiece) {
          html += "</div>";
        }
      } else if (item.type == "select") {
        if (onlyShow.length > 0 && onlyShow != finalNamePiece) {
          html += "<div style='display: none'>";
        }
        
        html += "<p><select id='" + id + "' name='" + name + "' class='" + cssclasses + "'><option value=''>" + item.placeholder + "</option>";
        for (var j = 0; j < item.options.length; j++) {
          html += "<option value='" + item.options[j][1] + "'>" + item.options[j][0] + "</option>";
        }
        html += "</select></p>";

        if (onlyShow.length > 0 && onlyShow != finalNamePiece) {
          html += "</div>";
        }
      } else if (item.type == "renderpartial") {
        if (onlyShow.length > 0 && onlyShow != finalNamePiece) {
          html += "<div style='display: none'>";
        }
        
        item.namePrefix = name;
        item.id = "remote_placeholder_" + id;
        html += "<p id='" + item.id + "'>Loading...</p>";
        futures.push(item);

        if (onlyShow.length > 0 && onlyShow != finalNamePiece) {
          html += "</div>";
        }
      } else if (item.type == "raw") {
        if (onlyShow.length > 0 && onlyShow != finalNamePiece) {
          html += "<div style='display: none'>";
        }
        
        html += item.value;

        if (onlyShow.length > 0 && onlyShow != finalNamePiece) {
          html += "</div>";
        }
      } else {
        if (onlyShow.length > 0 && onlyShow != finalNamePiece) {
          html += "<div style='display: none'>";
        }
        
        var inputType = item.type;
        if (item.type == "position") {
          inputType = "hidden";
          has_position = true;
        }
        if (!myplaceonline.isFocusAllowed()) {
          if (inputType != "file" && inputType != "hidden") {
            inputType = "text";
          }
        }
        html += "<p>";
        if (item.allowmultiple) {
          html += item.multiple_allowed + "<br />";
        }
        html += "<input type='" + inputType + "' id='" + id + "' name='" + name + "' placeholder='" + item.placeholder + "' value='" + defaultValue + "' class='" + cssclasses + "'";
        if (item.step) {
          html += " step='" + item.step + "'";
        }
        if (item.useprogress) {
          html += " data-useprogress='true'";
        }
        if (item.position_field) {
          html += " data-position_field='" + item.position_field + "'";
        }
        if (item.allowmultiple) {
          html += " multiple";
        }
        html += " /></p>";

        if (onlyShow.length > 0 && onlyShow != finalNamePiece) {
          html += "</div>";
        }
      }
    }
    
    if (onlyShow.length > 0) {
      html += "<div style='display: none'>";
    }
    
    html += "<p><a href='#' onclick='return myplaceonline.formRemoveItem(this);' class='ui-btn ui-btn-icon-left ui-icon-delete ui-btn-inline'>" + deletePlaceholder + "</a></p>";

    if (onlyShow.length > 0) {
      html += "</div>";
    }
    
    html += "</div>";
    form_add_item_set_html($(link), html, toFocus);
    if (futures.length > 0) {
      myplaceonline.showLoading();
    }
    if (has_position) {
      form_set_positions(link);
    }
    if (futures.length > 0) {
      myplaceonline.saveCollapsibleStates();
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
        myplaceonline.ensureStyledPage();
        // Fire off any onPageLoad events
        $.mobile.pageContainer.trigger("pagecontainershow");
        scrollDown(200);
      }).fail(function(jqXHR, textStatus, errorThrown) {
        myplaceonline.createErrorNotification("Could not execute " + url + ": " + textStatus);
      }).complete(function(jqXHR, textStatus) {
        myplaceonline.hideLoading();
      });
    }
    return false;
  }

  function scrollDown(amount, easingType) {
    if (!easingType) {
      easingType = "easeInSine";
    }
    $('html, body').stop().animate({
      scrollTop: $(window).scrollTop() + amount
    }, 650, easingType);
  }

  function scrollTo(y, easingType) {
    if (!easingType) {
      easingType = "easeInSine";
    }
    $('html, body').stop().animate({
      scrollTop: y
    }, 650, easingType);
  }

  function html_calculation_operand(item, heading, idPrefix, namePrefix, input_name) {
    return '<div data-role="collapsible" data-collapsed="false"><h3>' + heading + '</h3><div data-role="collapsible-set"><div data-role="collapsible" data-collapsed="false"><h3>' + item.constant + '</h3><input type="text" id="' + idPrefix + '_' + input_name + '_constant_value" name="' + namePrefix + '[' + input_name + '][constant_value]" placeholder="' + item.constant_value + '" value="" class="" /></div><div data-role="collapsible" data-collapsed="true"><h3>' + item.sub_element + '</h3><div class="itemswrapper"><p><p><a href="#" onclick="return myplaceonline.formAddItem(this, \'' + namePrefix + '[' + input_name + '][calculation_element_attributes]\', \'' + item.delete + '\', [{ type: \'calculation_element\', left_heading: \'' + item.left_heading + '\', right_heading: \'' + item.right_heading + '\', constant_value: \'' + item.constant + '\', sub_element: \'' + item.sub_element + '\', constant: \'' + item.constant_value + '\', create: \'' + item.create + '\', delete: \'' + item.delete + '\', singleton: \'' + item.singleton + '\' }], \'' + item.singleton + '\', true);" class="ui-btn">' + item.create + '</a></p></p></div></div></div></div>';
  }

  function form_add_item_set_html(insertBefore, html, toFocus) {
    $(html).insertBefore(insertBefore);
    if (myplaceonline.prepareNewContent) {
      myplaceonline.prepareNewContent($(insertBefore).parent());
      if (toFocus) {
        myplaceonline.maybeFocus("#" + toFocus);
      }
    } else {
      alert("You are on an old version of the myplaceonline app, please update.");
    }
  }

  function formRemoveItem(link) {
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

  function formMoveItem(obj, moveType) {
    // Find the itemwrapper for our obj
    var itemwrapper = $(obj).parents(".itemwrapper").first();

    if (moveType == 1) {
      var search = itemwrapper[0].nextElementSibling;
      while (search) {
        if ($(search).hasClass("itemwrapper")) {
          itemwrapper.detach();
          $(search).after(itemwrapper);
          itemwrapper.trigger('create');
          break;
        }
        search = search.nextElementSibling;
      }
    } else if (moveType == -1) {
      var search = itemwrapper[0].previousElementSibling;
      while (search) {
        if ($(search).hasClass("itemwrapper")) {
          itemwrapper.detach();
          $(search).before(itemwrapper);
          itemwrapper.trigger('create');
          break;
        }
        search = search.previousElementSibling;
      }
    } else if (moveType == 2) {
      var finalWrapper = null;
      var search = itemwrapper[0].nextElementSibling;
      while (search) {
        if ($(search).hasClass("itemwrapper")) {
          finalWrapper = search;
        }
        search = search.nextElementSibling;
      }
      if (finalWrapper) {
        itemwrapper.detach();
        $(finalWrapper).after(itemwrapper);
        itemwrapper.trigger('create');
      }
    } else if (moveType == -2) {
      var finalWrapper = null;
      var search = itemwrapper[0].previousElementSibling;
      while (search) {
        if ($(search).hasClass("itemwrapper")) {
          finalWrapper = search;
        }
        search = search.previousElementSibling;
      }
      if (finalWrapper) {
        itemwrapper.detach();
        $(finalWrapper).before(itemwrapper);
        itemwrapper.trigger('create');
      }
    }
    
    form_set_positions(obj);
    scrollTo(itemwrapper.offset().top);
    return false;
  }

  function form_get_item_wrappers(obj) {
    var itemswrapper = $(obj).parents(".itemswrapper").first();
    var itemswrapper_id = itemswrapper.attr("id");
    return itemswrapper.find("." + itemswrapper_id);
  }

  function form_set_positions(obj, atItemsWrapper) {
    var itemswrapper = atItemsWrapper ? obj : $(obj).parents(".itemswrapper").first();
    var data_position_field = itemswrapper.data("position-field");
    if (data_position_field) {
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
  }

  function objectExtractId(obj) {
    return href_extract_id($(obj).attr("href"));
  }

  function href_extract_id(href) {
    href = href.replace(/\/edit/, "");
    var x = href.lastIndexOf("/"); 
    if (x != -1) {
      href = href.substring(x + 1);
    }
    return href;
  }

  function queueRequest(request) {
    queuedRequests.push(request);
    if (!queuedRequestThread) {
      queuedRequestThread = setTimeout(processQueuedRequest, 1000);
    }
  }

  function processQueuedRequest() {
    var newestRequests = {};
    for (var i = 0; i < queuedRequests.length; i++) {
      var request = queuedRequests[i];
      var existingRequest = newestRequests[request.url];
      if (existingRequest) {
        if (request.timestamp > existingRequest.timestamp) {
          newestRequests[request.url] = request;
        }
      } else {
        newestRequests[request.url] = request;
      }
    }
    for (var url in newestRequests) {
      var request = newestRequests[url];
      request.presend();
      $.ajax({
        url: request.url,
        method: request.method,
        dataType: request.dataType,
        data: request.data
      }).done(function(data, textStatus, jqXHR) {
        request.done(data, textStatus, jqXHR);
      }).fail(function(jqXHR, textStatus, errorThrown) {
        request.fail(jqXHR, textStatus, errorThrown);
      });
    }
    queuedRequests = [];
    queuedRequestThread = null;
  }

  function getBorderTitle(context) {
    var result = context.html();
    result = result.replace(/ \(.*\)/g, "");
    return result;
  }

  function notepadChanged(rte_wrapper_id, url, pendingSave, saving, saved, new_data) {
    queueRequest({
      url: url,
      method: "PATCH",
      dataType: "script",
      timestamp: new Date().getTime(),
      presend: function() {
        var titleObj = $(rte_wrapper_id).parents(".myplet_border").first().find(".myplet_border_title_content").first();
        titleObj.html(getBorderTitle(titleObj) + " (" + saving + ")");
      },
      data: {
        suppress_navigate: true,
        notepad: {
          notepad_data: new_data
        }
      },
      done: function(data, textStatus, jqXHR) {
        var titleObj = $(rte_wrapper_id).parents(".myplet_border").first().find(".myplet_border_title_content").first();
        titleObj.html(getBorderTitle(titleObj) + " (" + saved + ")");
        window.setTimeout(function() {
          var titleObj = $(rte_wrapper_id).parents(".myplet_border").first().find(".myplet_border_title_content").first();
          titleObj.html(getBorderTitle(titleObj));
        }, 1500);
      },
      fail: function(jqXHR, textStatus, errorThrown) {
        var titleObj = $(rte_wrapper_id).parents(".myplet_border").first().find(".myplet_border_title_content").first();
        titleObj.html(getBorderTitle(titleObj));
        myplaceonline.createErrorNotification("Could not execute " + url + ": " + textStatus);
      }
    });
  }

  function quickFeedback(prompt_text) {
    var result = prompt(prompt_text);
    if (result) {
      var url = "/api/quickfeedback.json";
      var data = {
        user_input: result,
        urlpath: window.location.pathname,
        urlsearch: window.location.search,
        urlhash: window.location.hash
      };
      $.ajax({
        url: url,
        method: "POST",
        dataType: "json",
        data: data
      }).done(function(data, textStatus, jqXHR) {
        myplaceonline.createSuccessNotification("Feedback submitted successfully");
      }).fail(function(jqXHR, textStatus, errorThrown) {
        myplaceonline.createErrorNotification("Could not execute " + url + ": " + textStatus);
      }).complete(function(jqXHR, textStatus) {
      });
    }
  }

  function addClass(obj, className) {
    if (!obj.hasClass(className)) {
      obj.addClass(className);
    }
  }

  function removeClass(obj, className) {
    if (obj.hasClass(className)) {
      obj.removeClass(className);
    }
  }

  function hideIfChecked(checkbox, objectToHide, callback) {
    if (checkbox.checked) {
      addClass($(checkbox).parent().children("label").first(), "hiding");
      if (!objectToHide) {
        objectToHide = $(checkbox).parent();
      }
      var hideTimeout = window.setTimeout(function(x) {
        if (x.callback) {
          x.callback(x.objectToHide, $(checkbox));
        } else {
          completeCheckboxHiding(x.objectToHide);
        }
      }, 1000, { objectToHide: objectToHide, callback: callback });
      $(checkbox).data("myplaceonline-is-hiding", hideTimeout);
    } else {
      if ($(checkbox).data("myplaceonline-is-hiding")) {
        cancelCheckboxHiding($(checkbox));
      }
    }
    return false;
  }
  
  function completeCheckboxHiding(objectToHide) {
    objectToHide.fadeOut();
  }
  
  function cancelCheckboxHiding($checkbox) {
    window.clearTimeout($checkbox.data("myplaceonline-is-hiding"));
    removeClass($checkbox.parent().children("label").first(), "hiding");
    $checkbox.prop('checked', false).checkboxradio('refresh');
  }
  
  function refreshWithParam(paramName, paramValue) {
    var url = removeParam(window.location.search, paramName);
    if (paramName) {
      if (url.indexOf('?') == -1) {
        url += "?" + paramName + "=" + paramValue;
      } else {
        url += "&" + paramName + "=" + paramValue;
      }
    }
    myplaceonline.navigate(window.location.pathname+url);
  }

  function removeParam(url, paramName) {
    if (paramName) {
      var searching = true;
      while (searching) {
        var x = url.indexOf("?" + paramName);
        if (x == -1) {
          x = url.indexOf("&" + paramName);
          if (x != -1) {
            var y = url.indexOf('&', x + 1);
            if (y == -1) {
              url = url.substring(0, x);
            } else {
              var remaining = url.substring(y);
              url = url.substring(0, x);
              if (url.indexOf('?') == -1) {
                url += "?" + remaining.substring(1);
              } else {
                url += remaining;
              }
            }
          } else {
            searching = false;
          }
        } else {
          var y = url.indexOf('&', x + 1);
          if (y == -1) {
            url = url.substring(0, x);
          } else {
            var remaining = url.substring(y);
            url = url.substring(0, x);
            if (url.indexOf('?') == -1) {
              url += "?" + remaining.substring(1);
            } else {
              url += remaining;
            }
          }
        }
      }
    }
    return url;
  }

  function requestGPS(target, requesting_gps, latitude, longitude, geolocation_unavailable, copy_to_clipboard) {
    $(target).html("<p>" + requesting_gps + "</p>");
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(location) {
        var maplink = "https://www.google.com/maps/place/" + location.coords.latitude + "," + location.coords.longitude;
        $(target).html("<p>" + latitude + ": " + location.coords.latitude + ", " + longitude + ": " + location.coords.longitude + "</p><p>" + location.coords.latitude + "," + location.coords.longitude + "</p><p><button class='clipboardable' data-clipboard-text='" + location.coords.latitude + "," + location.coords.longitude + "' onclick='return false;'>" + copy_to_clipboard + "</button></p><p><a href='" + maplink + "' target='_blank'>" + maplink + "</a></p>");
        myplaceonline.ensureClipboard($(".clipboardable"));
      });
    } else {
      $(target).html("<p>" + geolocation_unavailable + "</p>");
    }
    return false;
  }

  function requestGPS2(onSuccess) {
    if (navigator.geolocation) {
      myplaceonline.showLoading();
      navigator.geolocation.getCurrentPosition(function(location) {
        myplaceonline.hideLoading();
        onSuccess(location);
      }, function(err) {
        myplaceonline.hideLoading();
        myplaceonline.createErrorNotification("GPS failed: " + err);
      });
    } else {
      myplaceonline.createErrorNotification("GPS not available (navigator.geolocation is null)");
    }
    return false;
  }

  function playFirstSong(search) {
    var audioElements = $(search).find("audio");
    if (audioElements.length) {
      audioElements[0].play();
    }
  }
  
  function playNextSong(search) {
    var audioElements = $(search).find("audio");
    if (audioElements.length) {
      for (var i = 0; i < audioElements.length - 1; i++) {
        if (!audioElements[i].paused) {
          audioElements[i].pause();
          audioElements[i + 1].play();
          break;
        }
      }
    }
  }
  
  function playPreviousSong(search) {
    var audioElements = $(search).find("audio");
    if (audioElements.length) {
      for (var i = 1; i < audioElements.length; i++) {
        if (!audioElements[i].paused) {
          audioElements[i].pause();
          audioElements[i - 1].play();
          break;
        }
      }
    }
  }
  
  function pauseSongs(search) {
    var audioElements = $(search).find("audio");
    if (audioElements.length) {
      for (var i = 0; i < audioElements.length; i++) {
        if (!audioElements[i].paused) {
          audioElements[i].pause();
        }
      }
    }
  }
  
  function onChangeCascade(myobj, transformValueFunc, parentSelector, childSelector, intermediateSelector, intermediateTransform, finalTransform, initialTransformValueFunc) {
    var currentValue = $(myobj).val();
    if (initialTransformValueFunc) {
      currentValue = initialTransformValueFunc(currentValue);
      $(myobj).val(currentValue);
    }
    if (transformValueFunc) {
      currentValue = transformValueFunc(currentValue);
    }
    var parent = $(myobj).parents(parentSelector).first();
    var searchResult = parent.find(childSelector).first();
    var intermediate = null;
    
    if (intermediateSelector) {
      intermediate = parent.find(intermediateSelector).first().val();
      currentValue = intermediateTransform(currentValue, intermediate);
    }
    
    if (finalTransform) {
      currentValue = finalTransform(currentValue, intermediate);
    }
    
    searchResult.val(currentValue.toFixed(2));
    
    return true;
  }
  
  function toFloatSafe(someVal) {
    var result = parseFloat(someVal.replace(/,/g, ""));
    if (!isFinite(result)) {
      result = 0;
    }
    return result;
  }
  
  function transformMultiply(x, y) {
    return x * y;
  }
  
  function transformTrim(str) {
    return $.trim(str);
  }
  
  function setCsrfToken(token) {
    var metaTag = $("meta[name='csrf-token']");
    if (metaTag.length == 0) {
      $('<meta name="csrf-param" content="authenticity_token" />').appendTo('head');
      metaTag = $('<meta name="csrf-token" content="" />').appendTo('head');
    }
    metaTag.attr("content", token);
  }
  
  function checkSendDebug(message, errorObj, stackTrace, dontAlert) {
    var result = true;
    if (errorObj && errorObj.stack) {
      var errorObjStack = errorObj.stack.toLowerCase();
      if (stackTrace) {
        stackTrace = stackTrace.toLowerCase();
      } else {
        stackTrace = "";
      }
      var blacklist = [];
      
      // CKeditor doesn't handle AJAX page transitions gracefully
      blacklist.push("ckeditor");
      
      // Appears to be related to CKEditor (same as above)
      // TypeError: Cannot read property 'getComputedStyle' of undefined
      //   at $.eval [as getComputedStyle] (eval at <anonymous> (file:///android_asset/www/js/jquery-1.11.2.min.js:2:2622), <anonymous>:10440:296)
      //   at $.getDirection (eval at <anonymous> (file:///android_asset/www/js/jquery-1.11.2.min.js:2:2622), <anonymous>:10463:386)
      //   at $.setup (eval at <anonymous> (file:///android_asset/www/js/jquery-1.11.2.min.js:2:2622), <anonymous>:10711:171)
      //   at $.m (eval at <anonymous> (file:///android_asset/www/js/jquery-1.11.2.min.js:2:2622), <anonymous>:11213:310)
      //   at eval (eval at <anonymous> (file:///android_asset/www/js/jquery-1.11.2.min.js:2:2622), <anonymous>:10367:472)
      blacklist.push("Cannot read property 'getComputedStyle' of undefined");
      
      // https://github.com/zeroclipboard/zeroclipboard/issues/661
      blacklist.push("Bad NPObject as private data!");

      // https://github.com/zeroclipboard/zeroclipboard/issues/676
      blacklist.push("Error calling method on NPObject!");
      
      for (var i = 0; i < blacklist.length; i++) {
        var checkItem = blacklist[i];
        if (errorObjStack.indexOf(checkItem) != -1 || message.indexOf(checkItem) != -1 || stackTrace.indexOf(checkItem) != -1) {
          result = false;
          break;
        }
      }
      
      var whitelist = [];
      
      // There's a known issue with a ckeditor error: TypeError: null is not an object (evaluating 'elem.childNodes')
      // The proximate stack frame is bfsOrder, called from toMarkdown
      whitelist.push("bfsOrder");

      for (var i = 0; i < whitelist.length; i++) {
        var checkItem = whitelist[i];
        if (errorObjStack.indexOf(checkItem) != -1 || message.indexOf(checkItem) != -1 || stackTrace.indexOf(checkItem) != -1) {
          result = true;
          break;
        }
      }
    }
    if (result) {
      if (debugsSent >= 3) {
        result = false;
      } else {
        debugsSent++;
      }
    }
    return result;
  }
  
  function mypToMarkdown(html) {
    try {
      var result = toMarkdown(html);
      return result;
    } catch (e) {
      myplaceonline.sendDebug("Error converting to markdown for " + html, true, e);
      alert("Error processing text. We've been notified of the problem. Please save your content elsewhere, refresh, and try again until we fix it.");
      throw e;
    }
  }
  
  // Public API
  mymodule.hookListviewSearch = hookListviewSearch;
  mymodule.hookListviewEnter = hookListviewEnter;
  mymodule.getRemoteString = getRemoteString;
  mymodule.formAddItem = formAddItem;
  mymodule.formRemoveItem = formRemoveItem;
  mymodule.formMoveItem = formMoveItem;
  mymodule.objectExtractId = objectExtractId;
  mymodule.notepadChanged = notepadChanged;
  mymodule.quickFeedback = quickFeedback;
  mymodule.hideIfChecked = hideIfChecked;
  mymodule.refreshWithParam = refreshWithParam;
  mymodule.requestGPS = requestGPS;
  mymodule.requestGPS2 = requestGPS2;
  mymodule.playFirstSong = playFirstSong;
  mymodule.playNextSong = playNextSong;
  mymodule.playPreviousSong = playPreviousSong;
  mymodule.pauseSongs = pauseSongs;
  mymodule.onChangeCascade = onChangeCascade;
  mymodule.toFloatSafe = toFloatSafe;
  mymodule.transformMultiply = transformMultiply;
  mymodule.setCsrfToken = setCsrfToken;
  mymodule.listviewSearch = listviewSearch;
  mymodule.remoteDataListInitialize = remoteDataListInitialize;
  mymodule.jqmSetListMessage = jqmSetListMessage;
  mymodule.jqmSetList = jqmSetList;
  mymodule.jqmReplaceListSection = jqmReplaceListSection;
  mymodule.jqmListNext = jqmListNext;
  mymodule.jqmListPrevious = jqmListPrevious;
  mymodule.remoteDataListReset = remoteDataListReset;
  mymodule.form_set_positions = form_set_positions;
  mymodule.cancelCheckboxHiding = cancelCheckboxHiding;
  mymodule.completeCheckboxHiding = completeCheckboxHiding;
  mymodule.checkSendDebug = checkSendDebug;
  mymodule.transformTrim = transformTrim;
  mymodule.toMarkdown = mypToMarkdown;
  
  myplaceonline.onPageLoad(function() {
    if (ZeroClipboard) {
      ZeroClipboard.on("error", function(e) {
        myplaceonline.consoleLog("ZeroClipboard error: " + e);
        //if (Error) {
        //  myplaceonline.consoleLog("Handler stack:");
        //  myplaceonline.consoleLog(new Error().stack);
        //}
        if (e && e.stack) {
         myplaceonline.consoleLog("Error stack:");
         myplaceonline.consoleLog(e.stack);
        }
        myplaceonline.consoleLog("Console dir of error object:");
        myplaceonline.consoleDir(e);
        myplaceonline.consoleLog("ZC state:");
        myplaceonline.consoleLog(JSON.stringify(ZeroClipboard.state(), null, 2));
      });
    }
  });

  return mymodule;

}(myplaceonline || {});

// jquery-mobile-datebox requires global function callbacks
function dateboxCalendarClosed(update) {
  // If the input element's value is blank, then we assume
  // the user has hit the clear button and we don't bother
  // asking for the time
  if (this.element.val().length > 0) {
    var timebox = $("#" + this.element.data("datetime-id"));
    timebox.data("calendar-id", this.element.attr("id"));
    timebox.datebox('open');
  }
}

function dateboxTimeboxClosed(update) {
  var cal = $("#" + this.element.data("calendar-id"));
  var calDate = cal.datebox('getTheDate');
  calDate.setHours(update.date.getHours(), update.date.getMinutes(), update.date.getSeconds(), update.date.getMilliseconds());
  cal.datebox('setTheDate', calDate);
}
