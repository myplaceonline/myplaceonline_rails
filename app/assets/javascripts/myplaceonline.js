// myplaceonline.js
//
// Notes:
//  * When changing this file, apply the same changes in phonegap and push
//    out a new app build:
//    $ cp app/assets/ja*/myplaceonline.js ../myplaceonline_phonegap/www/js/
//    $ cp www/js/myplaceonline.js ../myplaceonline_rails/app/assets/ja*/
//  * This file should be loaded after jQuery but before jQueryMobile,
//    so any jQueryMobile specific executions (outside function definitions
//    and callbacks) may be done in the mobileinit callback.
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
  
  var baseurl = "https://myplaceonline.com/";
  var snapshotKey = "myplaceonline_offline_snapshot";
  var contact_email = "contact@myplaceonline.com";
  var allowFocusPlaceholder = true;
  var maxjserrors = 10;
  var maxjsonobj = 200;
  var heightPadding = 41;
  var debug = false;
  var loadedResources = [];
  var onetimeFunctions = [];
  var jserrors = 0;
  var holderrors = "";
  var debugMessages = [];
  var inPhoneGap = false;
  var audioMarkers = [];
  var collapseStates = {};
  var muted = true;
  var redirectAnchor = null;
  var clipboard_integration = 1;
  var initialPhonegapPage = false;
  var pendingPageLoads = [];
  var lastuniqueid = 1;
  
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/Trim
  if (!String.prototype.trim) {
    String.prototype.trim = function() {
      return this.replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, '');
    };
  }
  
  function startsWith(str, search) {
    if (str && search && str.length >= search.length && str.substring(0, search.length) == search) {
      return true;
    }
    return false;
  }
  
  function consoleLog(msg) {
    if (debug) {
      if (window.console) {
        window.console.log(new Date() + ": " + msg);
      }
      var t = new Date().toTimeString();
      var i = t.indexOf(' ');
      if (i != -1) {
        t = t.substr(0, i);
      }
      debugMessages.push(t + ": " + msg);
    }
  }

  function consoleDir(obj) {
    if (obj && debug) {
      if (window.console && window.console.dir) {
        window.console.dir(obj);
      }
      consoleLog("consoleDir JSON: " + getJSON(obj));
    }
  }

  function showDebugConsole() {
    var result = "";
    for (var i in debugMessages) {
      result = debugMessages[i] + "\n" + result;
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
  
  function getAllHTML() {
    return document.documentElement ? document.documentElement.innerHTML : "documentElement null";
  }

  function sendDebug(message, dontAlert, errorObj) {
    var stackTrace = null;
    var dosend = true;
    if (Error) {
      // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error/Stack
      stackTrace = new Error().stack;
      
      if (errorObj && errorObj.stack) {
        stackTrace = errorObj.stack + "\n\nsendDebug stack:\n" + stackTrace;
      }
    }
    if (myplaceonline.checkSendDebug) {
      dosend = myplaceonline.checkSendDebug(message, errorObj, stackTrace, dontAlert);
    }
    if (dosend) {
      // URL is absolute because the call might come from phonegap
      $.ajax({
        type: "POST",
        url: baseurl + "api/debug",
        dataType: "json",
        contentType: "application/json",
        async: true,
        data: JSON.stringify({
          message: message,
          messages: debugMessages,
          //html: getAllHTML(),
          stack: stackTrace
        })
      }).done(function(data) {
        if (!dontAlert) {
          alert("We've received your data.");
        }
      }).fail(function(data) {
        if (!dontAlert) {
          alert("Error contacting our server.");
        }
      });
    }
    return dosend;
  }

  function getJSON(obj, max) {
    if (obj) {
      if (!max) {
        max = maxjsonobj; 
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
        if (!result) {
          result = obj.toString();
        }
        if (result && result.length > max) {
          result = result.substring(0, max) + "...";
        }
        return result;
      } catch (e) {
        return "getJSON failed (error " + e + ", object: " + obj + ")";
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

  function criticalError(msg, errorObj) {
    msg = "Application Error. The details have been reported to us and we'll investigate. Details: " + msg;
    
    if (errorObj && errorObj.message) {
      msg += " (" + errorObj.message + ")";
    }
    
    consoleLog(msg);
    if (debug && errorObj && errorObj.stack) {
      consoleLog(errorObj.stack);
    }
    jserrors++;
    if (jserrors <= maxjserrors) {
      if (sendDebug(msg, true, errorObj)) {
        alert(msg);
        
        // TODO: create some sort of UI element
        // that shows that their browser session might be in a weird state,
        // show the list of warnings, and recommend to consider refreshing.
      }
    }
  }

  window.onerror = function(msg, url, line, colno, errorObj) {
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
              details = "Error Event: " + getJSON(msg.target, maxjsonobj);
              jsondetails = msg;
            }
            
          } else {
            details = "Event=" + msg.type;
            jsondetails = msg;
          }
        } else {
          details = getJSON(msg, maxjsonobj);
          jsondetails = msg;
        }
      }
    } catch (e) {
      criticalError("Error processing msg", e);
    }

    var errorMsg = details + "\nurl: " + url + "\nline #: " + line;
    if (colno) {
      errorMsg += " (" + colno + ")";
    }
    errorMsg += "\ntype: " + t;

    criticalError(errorMsg, errorObj);

    holderrors += "\n\n" + errorMsg;
    if (jsondetails) {
      try {
        holderrors += "\n\nFull JSON: " + getJSON(jsondetails, 1000000);
      } catch (e) {
        criticalError("Error calling getJSON", e);
      }
    }
    
    setTimeout(function() {
      var debugConsole = document.getElementById("debugConsole");
      if (debugConsole) {
        debugConsole.value = holderrors + debugConsole.value;
        holderrors = "";
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
  
  function prepareNewContent($element) {
    if ($element) {
      $element.trigger("create");
    }
    if (inPhoneGap) {
      var process = null;
      if ($element) {
        process = $element.find("input:file");
      } else {
        process = $("input:file");
      }
      process.each(function(index) {
        var $this = $(this);
        if ($this.data("useprogress")) {
          $("<button class='take_picture_button ui-btn'>Take Picture</button>").insertAfter($this);
        }
      });
    }
  }
  
  function getUploadLink() {
    // Must be newfile instead of newfile2 for phonegap
    // See nginx.conf.template
    if (myplaceonline.isInPhoneGap()) {
      return "/api/newfile";
    } else {
      return "/api/newfile2";
    }
  }
  
  // http://api.jquerymobile.com/global-config/
  $(document).on("mobileinit.myp", function() {
    consoleLog("mobileinit.myp");
    
    $.mobile.hoverDelay = 100;
    //$.mobile.defaultPageTransition = "slide";
    $.mobile.defaultPageTransition = "none";
    $.ajaxSetup({
      timeout: 60000
    });
    
    if (navigator) {
      var ua = navigator.userAgent;
      if (ua && ua.indexOf('Android 2.3') != -1) {
        $.mobile.ajaxEnabled = false;
      }
    }
    
    $(document).bind("pagecontainershow.mypshow", function( e, ui ) {
      
      var activePage = getActivePage();
      
      consoleLog("pagecontainershow.mypshow activePage: " + (activePage ? $(activePage).data("url") : "null"));
      
      resetPendingPageLoads();
      
      /*
        var activePage = getActivePage();
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
      if (redirectAnchor && (!hash || hash == "")) {
        hash = redirectAnchor;
        redirectAnchor = null;
      }
      if (hash && hash != "" && hash.indexOf('ui-state') == -1) {
        var selector = ".ui-page-active a[name='" + hash.substr(1) + "']";
        consoleLog("Hash selector: " + selector);
        var anchor = $(selector);
        if (anchor.length) {
          scrollY(anchor.offset().top);
        }
      }
      
      prepareNewContent(null);
    });

    $(document).on("click", ".take_picture_button", function(e) {
      if (inPhoneGap) {
        consoleLog("Launching phone camera");
        $takePictureButton = $(this);
        $inputFileElement = $(this).prev("input:file").first();
        consoleDir($inputFileElement);
        navigator.camera.getPicture(function(fileURI) {
          consoleLog("Successfully captured picture at " + fileURI);
          window.resolveLocalFileSystemURL(fileURI, 
            function(fileEntry) {
              fileEntry.file(function(file) {
                consoleLog("Got File object");
                consoleDir(file);
                // See http://stackoverflow.com/questions/38688006/why-doesnt-formdata-append-file-from-fileentry-upload-correctly
                $uploading = $("<p>Uploading...</p>");
                $uploading.insertAfter($takePictureButton);
                $takePictureButton.hide();
                prepareUploadFiles($inputFileElement, 1);
                //uploadFile(file, $inputFileElement);
                var ft = new FileTransfer();
                var params = {
                  urlpath: window.location.pathname,
                  urlsearch: window.location.search,
                  urlhash: window.location.hash
                };
                if ($inputFileElement.data("position_field")) {
                  params.position_field = $inputFileElement.data("position_field");
                }
                ft.upload(
                  fileURI,
                  encodeURI(app.base_url + myplaceonline.getUploadLink()),
                  function(result) {
                    $uploading.remove();
                    var resultObj = jQuery.parseJSON(result.response);
                    consoleDir(resultObj);
                    uploadFileSuccess(resultObj, null, $inputFileElement);
                    uploadFileAlways($inputFileElement);
                  },
                  function(error) {
                    $uploading.remove();
                    consoleDir(error);
                    criticalError("Could not upload file: " + error.body);
                    consoleLog("upload error source " + error.source);
                    consoleLog("upload error target " + error.target);
                  },
                  {
                    fileKey: $inputFileElement.attr("name"),
                    fileName: file.name,
                    mimeType: file.type,
                    params: params,
                    headers: {
                      "X-CSRF-Token": $("meta[name='csrf-token']").attr("content")
                    }
                  },
                  false,
                  false
                );
              }, function() {
                criticalError("Could not get file object");
              });
            },
            function() {
              criticalError("Error resolving picture location");
            }
          );
        }, function() {
          criticalError("Error getting picture");
        }, {
          // https://github.com/apache/cordova-plugin-camera#module_camera.CameraOptions
          destinationType: window.Camera.DestinationType.FILE_URI,
          sourceType: window.Camera.PictureSourceType.CAMERA
        });
      }
      return false;
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
      if ($.mobile.getAttribute( this, "role" ) == "visible" || $.mobile.getAttribute( this, "forcevisible" )) {
        return false;
      }
      searchValue = searchValue.toLowerCase();
      return ( ( "" + ( $.mobile.getAttribute( this, "filtertext" ) || $( this ).text() ) ).toLowerCase().indexOf( searchValue ) === -1 );
    }

    if ($.mobile.ajaxEnabled) {
      $(document).on('click', 'a', function(ev) {
        var href = $(this).attr('href');
        if (href && !startsWith(href, "#") && ((startsWith(href, "/") && !startsWith(href, "//")) || href.indexOf("://") == -1)) {
          var i = href.indexOf("#");
          if (i != -1) {
            var hash = href.substr(i);
            href = href.substr(0, i);
            // TODO global var not the most elegant!
            redirectAnchor = hash;
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

    // http://api.jquerymobile.com/pagecontainer/#event-loadfailed
    $(document).on("pagecontainerloadfailed", $.mobile.pageContainer, function(event, data) {
      // https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest#Properties
      jserrors++;
      if (jserrors <= maxjserrors) {
        if (data.xhr.status == 0 && !data.xhr.responseText) {
          alert("Could not communicate with server. This could be caused by:\n* Internet connection problem\n* Server is under maintenance\n\nPlease try again or report the error to " + contact_email);
        } else {
          alert("Error " + data.xhr.status + "\n" + data.xhr.responseText + "\n\nPlease try again or report the error to " + contact_email);
          data.xhr.responseText = null;
        }
      }
      // https://github.com/jquery/jquery-mobile/issues/3143
      //event.preventDefault();
      //data.deferred.reject( data.absUrl, data.options );
    });
  });

  function prepareUploadFiles($inputFileElement, numFiles) {
    // We hide the input element immediately and then we'll destroy it
    // when all the files have been uploaded
    $inputFileElement.hide();
    $inputFileElement.attr("files_selected", numFiles);
    $inputFileElement.attr("files_processed", 0);
  }
  
  function uploadFileSuccess(data, tracker, fileControl) {
    if (data.result) {
      
      if (tracker) {
        tracker.remove();
      }
      
      if (data.singular) {
        $(data.items[0].value).insertAfter(fileControl);
        var singularNamePrefix = "identity_file";
        if (data.singularNamePrefix) {
          singularNamePrefix = data.singularNamePrefix;
        }
        $("<input type='hidden' name='" + singularNamePrefix + "[id]' value='" + data.id + "' />").insertAfter(fileControl);
        
        // Don't show a success notification because then the user might not click Save
        // myplaceonline.createSuccessNotification(data.successNotification);
      } else {
        // Assume the file element's name is of the form:
        // $nameprefix[$number][identity_file_attributes][file]
        // So for the first parameter of the formAddItem call, we can
        // just chop off everything after $nameprefix
        
        var namePrefix = fileControl.attr("name");
        namePrefix = namePrefix.substring(0, namePrefix.lastIndexOf('['));
        namePrefix = namePrefix.substring(0, namePrefix.lastIndexOf('['));
        namePrefix = namePrefix.substring(0, namePrefix.lastIndexOf('['));
        myplaceonline.formAddItem(fileControl.parents(".itemswrapper").first().children().first(), namePrefix, data.deletePlaceholder, data.items);
        myplaceonline.form_set_positions(fileControl);
        myplaceonline.createSuccessNotification(data.successNotification + " (" + (parseInt(fileControl.attr("files_processed")) + 1) + "/" + fileControl.attr("files_selected") + ")");
      }
    } else {
      myplaceonline.createErrorNotification("Unknown error. We've been notified. You may try again although we recommend refreshing the page first to remove any invalid state.");
    }
  }
  
  function uploadFileAlways(fileControl) {
    var files_processed = fileControl.attr("files_processed");
    files_processed++;
    fileControl.attr("files_processed", files_processed);
    if (files_processed == fileControl.attr("files_selected")) {
      var itemswrapper = fileControl.parents(".itemswrapper").first();
      if (itemswrapper.length > 0) {
        fileControl.parents(".itemwrapper").first().remove();
        myplaceonline.form_set_positions(itemswrapper, true);
      } else {
        fileControl.remove();
      }
    }
  }
  
  function uploadFile(file, $inputFileElement) {
    var filename = file.name;
    var filesize = file.size;
    var filetype = file.type;
    
    consoleLog("uploadFile name: " + filename + ", size: " + filesize + ", type: " + filetype);
    consoleDir(file);
    
    var formData = new FormData();

    // We need to include the parent object ID, if any
    formData.append($inputFileElement.attr("name"), file);

    // https://developer.mozilla.org/en-US/docs/Web/API/Location
    formData.append("urlpath", window.location.pathname == "/" ? $inputFileElement[0].form.action : window.location.pathname);
            
    if ($inputFileElement.data("position_field")) {
      formData.append("position_field", $inputFileElement.data("position_field"));
    }
            
    var progressid = nextUniqueId();
    
    // Create a progress element and cancel button right below the
    // input field
    var newhtml = $("<fieldset class=\"progress_fieldset\"><legend>" + encodeEntities(filename) + "</legend><progress id=\"" + progressid + "\" class=\"width100\"></progress><button class=\"ui-btn\">Cancel</button></fieldset>");
    newhtml.insertAfter($inputFileElement);
    
    var filecontext = {
      tracker: newhtml,
      fileControl: $inputFileElement
    };

    var jqxhr = $.ajax({
      type: "POST",
      url: myplaceonline.getUploadLink(),
      data: formData,
      timeout: 0,
      context: filecontext,
      xhr: function() {
        var myXhr = $.ajaxSettings.xhr();
        if (myXhr.upload){
          $(myXhr.upload).bind("progress", { progressid: progressid }, function(e) {
            if (e.originalEvent.lengthComputable) {
              $("#" + e.data.progressid).attr({
                value: e.originalEvent.loaded,
                max: e.originalEvent.total
              });
            }
          }, false);
        }
        return myXhr;
      },
      cache: false,
      contentType: false,
      processData: false
    }).done(function(data) {
      uploadFileSuccess(data, this.tracker, this.fileControl);
    }).fail(function(data) {
      if (data.statusText != "abort") {
        myplaceonline.createErrorNotification("Unknown error. We've been notified. You may try again although we recommend refreshing the page first to remove any invalid state.");
      }
    }).always(function() {
      uploadFileAlways(this.fileControl);
    });
    
    filecontext.jqxhr = jqxhr;

    newhtml.on("click", "button", filecontext, function(e) {
      e.preventDefault();
      
      // If it already completed successfully, then don't bother doing
      // anything
      if (e.data.jqxhr.readyState != 4) {
        // It didn't complete, so abort the request to stop sending
        // any pending data
        e.data.jqxhr.abort();
        
        // However, it's possible the full POST has already been sent,
        // in which case the file is already attached to the parent
        // object. So we need to delete the file, so what we'll
        // do is mark the context as pending delete and then when the
        // request finishes, if the user hasn't completely navigated away,
        // then we can separately delete it
        
        filecontext.pendingDelete = true; // TODO handle on the server side
      }
    });
  }

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
    var wrappedFunc = function(event, ui) {
      try {
        //myplaceonline.consoleLog("Running onPageLoad function");
        if (debug) {
          //myplaceonline.consoleDir(func);
        }
        func(event, ui);
      } catch (e) {
        criticalError("Error processing onPageLoad", e);
      }
      //myplaceonline.consoleLog("Finished onPageLoad function");
    };
    if (debug) {
      //myplaceonline.consoleLog("Binding onPageLoad func");
    }
    //myplaceonline.consoleDir(func);
    $(document).one("pagecontainershow", $.mobile.pageContainer, wrappedFunc);
    pendingPageLoads.push(wrappedFunc);
  }
  
  function resetPendingPageLoads() {
    pendingPageLoads = [];
  }

  function runPendingPageLoads() {
    myplaceonline.consoleLog("runPendingPageLoads count: " + pendingPageLoads.length);
    var i;
    for (i = 0; i < pendingPageLoads.length; i++) {
      var pendingPageLoad = pendingPageLoads[i];
      $(document).off("pagecontainershow", $.mobile.pageContainer, pendingPageLoad);
      pendingPageLoad();
    }
    myplaceonline.consoleLog("runPendingPageLoads resetPendingPageLoads");
    resetPendingPageLoads();
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
    for (var i in onetimeFunctions) {
      if (onetimeFunctions[i] == name) {
        return false;
      }
    }
    onetimeFunctions.push(name);
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
      for (var i in loadedResources) {
        if (loadedResources[i] == url) {
          consoleLog("loadExternalScript: script already loaded");
          if (successFunc) {
            successFunc();
          }
          return false;
        }
      }
    }
    loadedResources.push(url);
    return $.ajax({
      url: url,
      dataType: "script",
      success: successFunc,
      error: function(jqXHR, textStatus, errorThrown) {
        criticalError("Could not load " + url + " ; status: " + textStatus + ", errorThrown: " + errorThrown);
      },
      async: async
    });
  }

  function loadExternalCss(url, multiple) {
    consoleLog("loadExternalCss: url " + url + ", multiple " + multiple);
    if (!multiple) {
      for (var i in loadedResources) {
        if (loadedResources[i] == url) {
          return false;
        }
      }
    }
    $('head').append('<link rel="stylesheet" href="' + url + '" type="text/css" />');
    loadedResources.push(url);
    return true;
  }

  function saveCollapsibleStates() {
    var all_collapsibles = $(".ui-collapsible");
    collapseStates = {};
    all_collapsibles.each(function() {
      var collapsible = $(this);
      var id = $(collapsible).attr("id");
      if (!id) {
        id = "cbl" + Math.floor(Math.random()*100000000);
        $(collapsible).attr("id", id);
      }
      collapseStates[id] = $(collapsible).hasClass("ui-collapsible-collapsed");
    });
  }

  function restoreSavedCollapsibleStates() {
    if (collapseStates) {
      $.each(collapseStates, function (id, val) {
        var x = $("#" + id);
        if (val) {
          x.collapsible("collapse");
        } else {
          x.collapsible("expand");
        }
      });
      collapseStates = null;
    }
  }

  function ensureStyledPage() {
    if ($.mobile.activePage) {
      $.mobile.activePage.trigger('create');
      restoreSavedCollapsibleStates();
    }
  }

  function scrollTop(easingType) {
    scrollY(0, easingType);
  }

  // http://easings.net/
  function scrollY(y, easingType) {
    if (!easingType) {
      easingType = "easeInSine";
    }
    if (y > heightPadding) {
      y -= heightPadding;
    }
    $("html, body").stop().animate({
      scrollTop: y
    }, 650, easingType);
  }

  function playSound(audioFile) {
    try {
      consoleLog("playSound " + audioFile + ", muted: " + muted);
      if (!muted) {
        if (inPhoneGap) {
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
  // allowFocusPlaceholder=false; after
  // loading myplaceonline.js to disable.
  function maybeFocus(selector) {
    if (allowFocusPlaceholder) {
      $(selector).focus();
    }
  }

  function createSuccessNotification(message, timeout, encodeHTML) {
    if (noty) {
      if (!timeout) {
        timeout = 4000;
      }
      if (encodeHTML) {
        message = encodeEntities(message);
      }
      noty({text: message, layout: 'topCenter', type: 'success', timeout: timeout});
    } else {
      alert(message);
    }
  }

  function createErrorNotification(message, timeout, encodeHTML) {
    if (noty) {
      if (!timeout) {
        timeout = 4000;
      }
      if (encodeHTML) {
        message = encodeEntities(message);
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
    consoleLog(getAllHTML());
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

  function ensureClipboard(objects) {
    // If we're in PhoneGap, use the clipboard plugin; otherwise,
    // check if the user has overriden clipboard integration and use that
    // option or fall back to ZeroClipboard
    if (window.cordova && cordova.plugins && cordova.plugins.clipboard) {
      $("[data-clipboard-text]").click( function(e) {
        cordova.plugins.clipboard.copy($(this).data("clipboard-text"));
        createSuccessNotification("Copied '" + $(this).data("clipboard-text") + "' to clipboard.", null, true);
        return $(this).data("clipboard-clickthrough") == "yes" ? true : false;
      });
    } else {
      if (clipboard_integration === 2 && !window.ffclipboard) {
        clipboard_integration = 1;
      }
      if (clipboard_integration == 1) {
        var clipboard = new ZeroClipboard(objects);
        clipboard.on("ready", function(readyEvent) {
          clipboard.on("aftercopy", function(event) {
            createSuccessNotification("Copied '" + event.data["text/plain"] + "' to clipboard.", null, true);
          });
        });
      } else if (clipboard_integration == 2) {
        $("[data-clipboard-text]").click( function(e) {
          window.ffclipboard.setText($(this).data("clipboard-text"));
          createSuccessNotification("Copied '" + $(this).data("clipboard-text") + "' to clipboard.", null, true);
          return $(this).data("clipboard-clickthrough") == "yes" ? true : false;
        });
      }
    }
  }

  function setMyplaceonlineSnapshot(jsonObj) {
    if (window.localStorage) {
      window.localStorage.setItem(snapshotKey, JSON.stringify(jsonObj));
    }
  }

  function getMyplaceonlineSnapshot() {
    var result = window.localStorage ? window.localStorage.getItem(snapshotKey) : null;
    if (result) {
      try {
        result = JSON.parse(result);
      } catch (e) {
        window.localStorage.removeItem(snapshotKey);
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
  
  function nextUniqueId() {
    lastuniqueid++;
    return "element" + lastuniqueid;
  }

  function encodeEntities(str) {
    if (!str) {
      str = "";
    } else {
      str = str.toString();
    }
    return str.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#27;");
  }

  // Public API

  mymodule.startsWith = startsWith;
  mymodule.consoleLog = consoleLog;
  mymodule.consoleDir = consoleDir;
  mymodule.showDebugConsole = showDebugConsole;
  mymodule.sendDebug = sendDebug;
  mymodule.navigate = navigate;
  mymodule.refreshPage = refreshPage;
  mymodule.criticalError = criticalError;
  mymodule.getActivePage = getActivePage;
  mymodule.onPageLoad = onPageLoad;
  mymodule.pageloaded = pageloaded;
  mymodule.loadExternalScript = loadExternalScript;
  mymodule.loadExternalCss = loadExternalCss;
  mymodule.saveCollapsibleStates = saveCollapsibleStates;
  mymodule.ensureStyledPage = ensureStyledPage;
  mymodule.scrollTop = scrollTop;
  mymodule.scrollY = scrollY;
  mymodule.playSound = playSound;
  mymodule.maybeFocus = maybeFocus;
  mymodule.createSuccessNotification = createSuccessNotification;
  mymodule.createErrorNotification = createErrorNotification;
  mymodule.alertHTML = alertHTML;
  mymodule.showLoading = showLoading;
  mymodule.hideLoading = hideLoading;
  mymodule.ensureClipboard = ensureClipboard;
  mymodule.setMyplaceonlineSnapshot = setMyplaceonlineSnapshot;
  mymodule.getMyplaceonlineSnapshot = getMyplaceonlineSnapshot;
  mymodule.getSessionPassword = getSessionPassword;
  mymodule.getJSON = getJSON;
  mymodule.runPendingPageLoads = runPendingPageLoads;
  mymodule.prepareUploadFiles = prepareUploadFiles;
  mymodule.uploadFile = uploadFile;
  mymodule.nextUniqueId = nextUniqueId;
  mymodule.encodeEntities = encodeEntities;
  mymodule.prepareNewContent = prepareNewContent;
  mymodule.getCurrentRelativePathAndQuery = getCurrentRelativePathAndQuery;
  mymodule.getUploadLink = getUploadLink;

  mymodule.isFocusAllowed = function() {
    return allowFocusPlaceholder;
  };
  
  mymodule.setFocusAllowed = function(newvalue) {
    allowFocusPlaceholder = newvalue;
  };
  
  mymodule.setDebug = function(newvalue) {
    debug = newvalue;
  };
  
  mymodule.isDebug = function() {
    return debug;
  };
  
  mymodule.setInPhonegap = function(newvalue) {
    inPhoneGap = newvalue;
  };
  
  mymodule.isInPhoneGap = function() {
    return inPhoneGap;
  };
  
  mymodule.setIsInitialPhonegapPage = function(newvalue) {
    initialPhonegapPage = newvalue;
  };
  
  mymodule.isInitialPhonegapPage = function() {
    return initialPhonegapPage;
  };
  
  mymodule.setClipboardIntegration = function(newvalue) {
    clipboard_integration = newvalue;
  };
  
  mymodule.getSnapshotKey = function() {
    return snapshotKey;
  };
  
  mymodule.setBaseUrl = function(newvalue) {
    if (startsWith(newvalue, "http://localhost")) {
      baseurl = newvalue;
    }
  }
  
  return mymodule;

}(myplaceonline || {});
