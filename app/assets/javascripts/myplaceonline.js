// myplaceonline.js
// Version 0.5
//
// Notes:
//  * When changing this file, you may need to apply the same changes to
//    myplaceonline_phonegap/www/js/myplaceonline.js and do a new phonegap
//    build.
//  * This file should be loaded after jQuery but before jQueryMobile,
//    so any jQueryMobile specific executions (outside function definitions
//    and callbacks) may be done in the mobileinit callback.

var myp = {
  allowFocusPlaceholder: true,
  loadedScripts: [],
  onetimeFunctions: [],
  jserrors: 0,
  maxjserrors: 1,
  holderrors: "",
  maxjsonobj: 200,
  heightPadding: 41,
  debug: false,
  debugMessages: [],
  inPhoneGap: false,
  audioMarkers: [],
  snapshotKey: "myplaceonline_offline_snapshot"
};

function consoleLog(msg) {
  if (window.console) {
    window.console.log(msg);
  }
  if (myp.debug) {
    var t = new Date().toTimeString();
    var i = t.indexOf(' ');
    if (i != -1) {
      t = t.substr(0, i);
    }
    myp.debugMessages.push(t + ": " + msg);
  }
}

function consoleDir(obj) {
  if (obj) {
    if (window.console && window.console.dir) {
      window.console.dir(obj);
    }
    consoleLog(getJSON(obj));
  }
}

function showDebugConsole() {
  var result = "";
  for (var i in myp.debugMessages) {
    result = myp.debugMessages[i] + "\n" + result;
  }
  if (!document.getElementById("debugConsole")) {
    var el = document.createElement("textarea");
    el.id = "debugConsole";
    el.setAttribute("readonly", "true");
    el.style.cssText = "width: 95%; height: 300px;";

    var target = document.body;
    var mobilePage = getActivePage();
    if (mobilePage) {
      target = mobilePage;
    }

    var h1 = document.createElement("h1");
    h1.innerHTML = "Debug Console";

    target.appendChild(document.createElement("hr"));
    target.appendChild(document.createElement("p"));
    target.appendChild(h1);
    target.appendChild(el);

    var submitButton = document.createElement("button");
    submitButton.innerHTML = "Send to Support";
    submitButton.onclick = sendDebug;
    target.appendChild(submitButton);

    var refreshButton = document.createElement("button");
    refreshButton.innerHTML = "Refresh";
    refreshButton.onclick = function() {
      showDebugConsole();
    };
    target.appendChild(refreshButton);

    target.appendChild(document.createElement("p"));
  }
  document.getElementById("debugConsole").value = "Accumulated Messages:\n" + result;
}

function sendDebug() {
  // URL is absolute because the call might come from phonegap
  $.ajax({
    type: "POST",
    url: "https://myplaceonline.com/api/debug",
    dataType: "json",
    contentType: "application/json",
    async: true,
    data: JSON.stringify({
      messages: myp.debugMessages,
      html: document.documentElement.innerHTML
    })
  }).done(function(data) {
    alert("We've received your data.");
  }).fail(function(data) {
    alert("Error contacting our server. Please try again.");
  });
}

function getJSON(obj, max) {
  if (obj) {
    if (!max) {
      max = myp.maxjsonobj; 
    }
    var cache = [];
    try {
      var result = JSON.stringify(obj, function(key, value) {
        if (typeof value === 'object' && value !== null) {
          if (cache.indexOf(value) !== -1) {
            // Circular reference found, discard key
            return;
          }
          cache.push(value);
        }
        return value;
      });
      cache = null;
      if (result.length > max) {
        result = result.substring(0, max) + "...";
      }
      return result;
    } catch (e) {
      return "null (error " + e + ", " + obj + ")";
    }
  } else {
    return "null";
  }
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

function getCurrentRelativePathAndQuery(addTime) {
  var result = window.location.pathname+window.location.search;
  if (addTime) {
    if (result.indexOf('?') == -1) {
      result += "?";
    } else {
      result += "&";
    }
    result += "t=" + (new Date).getTime();
  }
  return result;
}

function refreshPage(resubmit) {
  if ($.mobile.ajaxEnabled) {
    var newurl = getCurrentRelativePathAndQuery(true);
    $.mobile.pageContainer.pagecontainer("change", newurl, {
      allowSamePageTransition: true,
      transition: 'none',
      reloadPage: true,
      changeHash: false
    });
  } else if (resubmit) {
    window.location.reload();
  } else {
    window.location.href = window.location.href;
  }
}

function submitForm(frm) {
  consoleLog("submitForm ajaxEnabled: " + $.mobile.ajaxEnabled);
  if ($.mobile.ajaxEnabled) {
    var $form = $(frm);
    var action = $form.attr('action');
    if (action == "") {
      consoleLog("submitForm blank action");
      action = getCurrentRelativePathAndQuery(true);
    }
    var m = $form.attr('method');
    consoleLog("submitForm action: " + action + ", method: " + m);
    $.mobile.pageContainer.pagecontainer("change", action, {
      type: m,
      allowSamePageTransition: true,
      data: $form.serialize(),
      reloadPage: true
    });
    return false;
  } else {
    return true;
  }
}

function criticalError(msg) {
  msg = "Browser Error. Please copy and report the following details to contact@myplaceonline.com: " + msg;
  consoleLog(msg);
  if (myp) {
    myp.jserrors++;
    if (myp.jserrors <= myp.maxjserrors) {
      alert(msg);
    }
  } else {
    alert(msg);
  }
}

window.onerror = function(msg, url, line) {
  // If you return true, then error alerts (like in older versions of 
  // Internet Explorer) will be suppressed.
  var suppressErrorAlert = true;
  var jsondetails = null;

  var t = "";
  var details = msg;
  try {
    t = typeof msg;
    if (msg != null && t === 'object') {
      // Check if this object is an event
      if (msg.type && msg.target) {
        
        // http://www.w3.org/TR/DOM-Level-3-Events/#events-module
        
        if (msg.type == "error") {
          // http://www.w3.org/TR/DOM-Level-3-Events/#event-type-error
          // http://www.whatwg.org/specs/web-apps/current-work/multipage/webappapis.html#report-the-error
          
          // If this is an error thrown by a script on a different domain,
          // then we don't get any details:
          // http://stackoverflow.com/a/7778424/2837226
          // http://blog.errorception.com/2012/04/script-error-on-line-0.html
          // TODO this doesn't actually check if it's cross domain
          if (msg.srcElement && msg.srcElement.type == "text/javascript") {
            consoleLog("Suppressing error from " + msg.srcElement.src); 
            return suppressErrorAlert;
          } else {
            details = "Error Event: " + getJSON(msg.target, myp.maxjsonobj);
            jsondetails = msg;
          }
          
        } else {
          details = "Event=" + msg.type;
          jsondetails = msg;
        }
      } else {
        details = getJSON(msg, myp.maxjsonobj);
        jsondetails = msg;
      }
    }
  } catch (e) {
    criticalError(e);
  }

  var errorMsg = details + "\nurl: " + url + "\nline #: " + line + "\ntype: " + t;

  criticalError(errorMsg);

  myp.holderrors += "\n\n" + errorMsg;
  if (jsondetails) {
    try {
      myp.holderrors += "\n\nFull JSON: " + getJSON(jsondetails, 1000000);
    } catch (e) {
      criticalError(e);
    }
  }
  
  setTimeout(function() {
    var debugConsole = document.getElementById("debugConsole");
    if (debugConsole) {
      debugConsole.value = myp.holderrors + debugConsole.value;
      myp.holderrors = "";
    }
  }, 5000);

  return suppressErrorAlert;
};

function getActivePage() {
  if (window.jQuery && $.mobile) {
    var mc = $(":mobile-pagecontainer");
    if (mc) {
      var ap = mc.pagecontainer("getActivePage");
      if (ap) {
        return ap[0];
      }
    }
  }
  return null;
}

// http://api.jquerymobile.com/global-config/
$(document).on("mobileinit.myp", function() {
  consoleLog("mobileinit.myp");
  
  $.mobile.hoverDelay = 100;
  $.mobile.defaultPageTransition = "slide";
  $.ajaxSetup({
    timeout: 15000
  });
  
  if (navigator) {
    var ua = navigator.userAgent;
    if (ua && ua.indexOf('Android 2.3') != -1) {
      $.mobile.ajaxEnabled = false;
    }
  }
  
  $(document).bind("pagecontainershow.mypshow", function( e, ui ) {
    var activePage = getActivePage();
    
    /*
    if (activePage) {
      consoleLog("pagecontainershow: " + activePage.id + "," + $(activePage).attr('data-uniqueid'));
      if (ui.prevPage && ui.prevPage.length > 0) {
        // Don't keep the previous page cached
        $(ui.prevPage[0]).remove();
      }
    } else {
      consoleLog("pagecontainershow no active page");
    }
    */

    // If there is a hash
    var hash = window.location.hash;
    if (myp.redirectAnchor && (!hash || hash == "")) {
      hash = myp.redirectAnchor;
      myp.redirectAnchor = null;
    }
    if (hash && hash != "" && hash.indexOf('ui-state') == -1) {
      var selector = ".ui-page-active a[name='" + hash.substr(1) + "']";
      consoleLog("Hash selector: " + selector);
      var anchor = $(selector);
      if (anchor.length) {
        scrollY(anchor.offset().top);
      }
    }
  });

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
  $(document).on("pagecontainerbeforeshow.notext", $.mobile.pageContainer, function(event, ui) {
    $.mobile.activePage.find('.ui-header a[data-rel=back]').buttonMarkup({iconpos: 'notext'});
  });
  
  // Override the default filterCallback to always show list items with
  // data-role="visible" in addition to the default behavior
  $.mobile.filterable.prototype.options.filterCallback = function (index, searchValue) {
    if ($.mobile.getAttribute( this, "role" ) == "visible") {
      return false;
    }
    searchValue = searchValue.toLowerCase();
    return ( ( "" + ( $.mobile.getAttribute( this, "filtertext" ) || $( this ).text() ) ).toLowerCase().indexOf( searchValue ) === -1 );
  }

  if ($.mobile.ajaxEnabled) {
    $(document).on('click', 'a.redirectAnchor', function(ev) {
      var href = $( this ).attr('href');
      if (href) {
        var i = href.indexOf("#");
        if (i != -1) {
          var hash = href.substr(i);
          href = href.substr(0, i);
          // TODO global var not the most elegant!
          myp.redirectAnchor = hash;
          navigate(href);
          return false;
        }
      }
      return true;
    });
  }
    
  $(document).on("pagebeforecreate.updatedataurl", "[data-role=page]", null, function(e) {
    var dataUrl = $(this).attr("data-url");
    $(this).attr("data-url",dataUrl.replace(/&amp;/g,"&"));
  });
});

function getActivePageUID() {
  var result = null;
  var activePage = getActivePage();
  if (activePage) {
    result = $(activePage).attr('data-uniqueid');
  }
  return result;
}

// func may optionally take event and ui parameters:
// http://api.jquerymobile.com/pagecontainer/#event-show
function onPageLoad(func) {
  $(document).one("pagecontainershow", $.mobile.pageContainer, func);
}

function pageloaded(uniqueid, func, namespace) {
  consoleLog("pageloaded hooking " + uniqueid + ", " + namespace);
  if ( $.mobile ) {
    var e = "pagecontainershow.loaded";
    if (namespace) {
      e += namespace;
    } else {
      e += uniqueid;
    }
    $( document ).off(e).on(e, null, {page: uniqueid, f: func, selector: e}, function(ev, ui) {
      var pc = $(":mobile-pagecontainer");
      if (pc) {
        var ap = pc.pagecontainer("getActivePage");
        if (ap) {
          if (ap[0] && $(ap[0])) {
            if ($(ap[0]).attr('data-uniqueid') == ev.data.page) {
              ev.data.f(ev, ui);
              $( document ).off(ev.data.selector);
            }
          } else {
            alert("pageloaded: getActivePage first element not found");
          }
        } else {
          alert("pageloaded: getActivePage not found");
        }
      } else {
        alert("pageloaded: pagecontainer not found");
      }
    });
  } else {
    $(document).ready(func);
  }
}

function pageunloaded(uniqueid, func, namespace) {
  consoleLog("pageunloaded hooking " + uniqueid + ", " + namespace);
  if ( $.mobile ) {
    var e = "pagecontainershow.unloaded";
    if (namespace) {
      e += namespace;
    } else {
      e += uniqueid;
    }
    $( document ).off(e).on(e, null, {page: uniqueid, f: func, selector: e}, function(ev, ui) {
      if (ui.prevPage && ui.prevPage.length > 0) {
        consoleLog("pageunloading with prevPage");
        var prevuid = $(ui.prevPage[0]).attr('data-uniqueid');
        if (prevuid == ev.data.page) {
          consoleLog("pageunloading, prevPage uid " + prevuid + " matched " + ev.data.selector);
          ev.data.f(ev, ui);
          $( document ).off(ev.data.selector);
        } else {
          consoleLog("pageunloading, prevPage uid " + prevuid + " didn't match " + ev.data.selector);
        }
      } else {
        consoleLog("pageunloading, no prevPage for " + ev.data.selector);
      }
    });
  }
}

function onetime(name, func) {
  for (var i in myp.onetimeFunctions) {
    if (myp.onetimeFunctions[i] == name) {
      return false;
    }
  }
  myp.onetimeFunctions.push(name);
  func();
  return true;
}

function arrayHasElement(ar, test) {
  for (var i in ar) {
    if (ar[i] == test) {
      return true;
    }
  }
  return false;
}

function arrayPushElement(ar, newElement) {
  ar.push(newElement);
}

/**
* If multiple is true, then always load the script, even if it has
* been loaded before. If it is false (the default if it is omitted), then
* do not reload the script again since it's already loaded. In the latter
* case, if the script is already loaded, successFunc is not called again.
* 
* @param url
* @param async
* @param successFunc
* @param multiple
*/
function loadExternalScript(url, async, successFunc, multiple) {
  consoleLog("loadExternalScript: url " + url + ", async " + async + ", multiple " + multiple);
  if (!multiple) {
    for (var i in myp.loadedScripts) {
      if (myp.loadedScripts[i] == url) {
        consoleLog("loadExternalScript: returning false");
        return false;
      }
    }
  }
  myp.loadedScripts.push(url);
  return $.ajax({
    url: url,
    dataType: 'script',
    success: successFunc,
    error: function() {
      criticalError('Could not load ' + url);
    },
    async: async
  });
}

function loadExternalCss(url, multiple) {
  if (!multiple) {
    for (var i in myp.loadedScripts) {
      if (myp.loadedScripts[i] == url) {
        return false;
      }
    }
  }
  $('head').append('<link rel="stylesheet" href="' + url + '" type="text/css" />');
  return true;
}

function ensureStyledPage() {
  if ($.mobile.activePage) {
    $.mobile.activePage.trigger('create');
  }
}

function scrollY(y) {
  y -= myp.heightPadding;
  $('html, body').stop().animate({
    scrollTop : y
  }, 650, "easeInOutExpo");
}

function playSound(audioFile) {
  try {
    consoleLog("playSound " + audioFile + ", muted: " + myp.muted);
    if (!myp.muted) {
      if (myp.inPhoneGap) {
        if (audioFile.charAt(0) == '/') {
          audioFile = audioFile.substring(1);
        }

        audioFile = app.phonegapPath + audioFile;

        var media = new Media(audioFile, function() {
          consoleLog("playSound success");
        }, function() {
          consoleLog("playSound failure");
        });
        media.play();
      } else {
        var snd = new Audio(audioFile);
        snd.play();
      }
    }
  } catch (soundError) {
    consoleLog("Could not play sound: " + soundError);
  }
}

// We often use the jqm feature of placeholder
// text in a textbox without a visible label. This means
// the only indiction of the purpose of a textbox
// is the placeholder text. In some browsers,
// if we focus on the textbox, the placeholder
// text goes away (and might also pop up the keyboard).
// So we try avoid doing a focus in
// those browsers. The default is that we allow
// the focus, but detection logic can output
// myp.allowFocusPlaceholder=false; after
// loading myp.js to disable.
function maybeFocus(selector) {
  if (myp.allowFocusPlaceholder) {
    $(selector).focus();
  }
}

function createSuccessNotification(message, timeout) {
  if (noty) {
    if (!timeout) {
      timeout = 4000;
    }
    noty({text: message, layout: 'topCenter', type: 'success', timeout: timeout});
  } else {
    alert(message);
  }
}

function createErrorNotification(message, duration, timeout) {
  if (noty) {
    if (!timeout) {
      timeout = 4000;
    }
    noty({text: message, layout: 'topCenter', type: 'error', timeout: timeout});
  } else {
    alert(message);
  }
}

// http://stackoverflow.com/a/9614662
jQuery.fn.visible = function() {
  return this.css('visibility', 'visible');
};

jQuery.fn.invisible = function() {
  return this.css('visibility', 'hidden');
};

jQuery.fn.visibilityToggle = function() {
  return this.css('visibility', function(i, visibility) {
    return (visibility == 'visible') ? 'hidden' : 'visible';
  });
};

function popup(href, name, width, height) {
  var specs = "location=1,resizable=1,scrollbars=1,status=1,toolbar=1,menubar=1,";
  if (!width) {
    width = 640;
  }
  if (!height) {
    height = 480;
  }
  specs += "width=" + width + ",height=" + height;
  var newwindow = window.open(href, name, specs);
  if (window.focus) {
    newwindow.focus();
  }
  return false;
}

function alertHTML() {
  consoleLog(document.documentElement.innerHTML);
  showDebugConsole();
}

function showLoading() {
  if ($.mobile) {
    $.mobile.loading('show');
  }
}

function hideLoading() {
  if ($.mobile) {
    $.mobile.loading('hide');
  }
}

function nonAjaxClick() {
  showLoading();
  return true;
}

function jqmSetListMessage(list, message) {
  list.html("<li data-role=\"visible\">" + message + "</li>");
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
    if (typeof x.count !== 'undefined') {
      html += "<li><a href='" + x.link + "'>" + x.title + " <span class='ui-li-count'>" + x.count + "</span></a></li>";
    } else {
      html += "<li><a href='" + x.link + "'>" + x.title + "</a></li>";
    }
  });
  list.html(html);
  list.listview("refresh");
  list.trigger("updatelayout");
}

function ensureClipboard(objects) {
  if (window.plugins && window.plugins.clipboard) {
    $("[data-clipboard-text]").click( function(e) {
      window.plugins.clipboard.copy($(this).data("clipboard-text"));
      createSuccessNotification("Copied to clipboard.");
      e.preventDefault();
      return false;
    });
  } else {
    var clipboard = new ZeroClipboard(objects);
    clipboard.on("ready", function(readyEvent) {
      clipboard.on("aftercopy", function(event) {
        createSuccessNotification("Copied to clipboard.");
      });
    });
  }
}

function setMyplaceonlineSnapshot(jsonObj) {
  if (window.localStorage) {
    window.localStorage.setItem(myp.snapshotKey, JSON.stringify(jsonObj));
  }
}

function getMyplaceonlineSnapshot() {
  var result = window.localStorage ? window.localStorage.getItem(myp.snapshotKey) : null;
  if (result) {
    try {
      result = JSON.parse(result);
    } catch (e) {
      window.localStorage.removeItem(myp.snapshotKey);
      throw e;
    }
  }
  return result;
}

function getSessionPassword() {
  if (!window.sessionPassword) {
    window.sessionPassword = prompt("Please enter your password:", "");
  }
  return window.sessionPassword;
}
