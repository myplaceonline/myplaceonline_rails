/*
 * jQuery-Mobile-DateBox 
 * Date: Fri Dec 5 2014 22:49:45 UTC
 * http://dev.jtsage.com/jQM-DateBox/
 * https://github.com/jtsage/jquery-mobile-datebox
 *
 * Copyright 2010, 2014 JTSage. and other contributors
 * Released under the MIT license.
 * https://github.com/jtsage/jquery-mobile-datebox/blob/master/LICENSE.txt
 *
 */


/* CORE Functions */

(function( $ ) {

        $.widget( "mobile.datebox", {
                initSelector: "input[data-role='datebox']",
                options: {
                        // All widget options, including some internal runtime details

                        // 3-jQueryMobileVersion
                        // Check Header for Build Date.
                        version: "3-1.4.5-05", 

                        theme: false,
                        themeDefault: "a",
                        themeHeader: "a",
                        themeSetButton: "a",
                        themeCloseButton: false,
                        mode: false,

                        transition: "fade",
                        useAnimation: true,
                        hideInput: false,
                        hideContainer: false,

                        lockInput: true,

                        zindex: "1100",
                        clickEvent: "vclick",
                        clickEventAlt: "click",

                        defaultValue: false,
                        showInitialValue: false,

                        popupPosition: false,
                        popupForceX: false,
                        popupForceY: false,

                        useModal: true,
                        useModalTheme: "b",
                        useInline: false,
                        useInlineBlind: false,
                        useHeader: true,
                        useImmediate: false,

                        useButton: true,
                        buttonIcon: false,
                        buttonIconDate: "calendar",
                        buttonIconTime: "clock",
                        useFocus: false,
                        useClearButton: false,
                        useCollapsedBut: false,
                        usePlaceholder: false,

                        beforeOpenCallback: false,
                        beforeOpenCallbackArgs: [],
                        openCallback: false,
                        openCallbackArgs: [],
                        closeCallback: false,
                        closeCallbackArgs: [],

                        startOffsetYears: false,
                        startOffsetMonths: false,
                        startOffsetDays: false,
                        afterToday: false,
                        beforeToday: false,
                        notToday: false,
                        maxDays: false,
                        minDays: false,
                        maxYear: false,
                        minYear: false,
                        blackDates: false,
                        blackDatesRec: false,
                        blackDays: false,
                        whiteDates: true,
                        minHour: false,
                        maxHour: false,
                        maxDur: false,
                        minDur: false,
                        minuteStep: 1,
                        minuteStepRound: 0,

                        rolloverMode: { 
                                "m": true,
                                "d": true,
                                "h": true,
                                "i": true,
                                "s": true
                        },

                        useLang: "default",
                        lang: {
                                "default" : {
                                        setDateButtonLabel: "Set Date",
                                        setTimeButtonLabel: "Set Time",
                                        setDurationButtonLabel: "Set Duration",
                                        calTodayButtonLabel: "Jump to Today",
                                        calTomorrowButtonLabel: "Jump to Tomorrow",
                                        titleDateDialogLabel: "Set Date",
                                        titleTimeDialogLabel: "Set Time",
                                        daysOfWeek: [
                                                "Sunday", "Monday", "Tuesday", 
                                                "Wednesday", "Thursday", "Friday", 
                                                "Saturday"
                                        ],
                                        daysOfWeekShort: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"],
                                        monthsOfYear: [
                                                "January", "February", "March", "April", "May", "June",
                                                "July", "August", "September", "October", "November", "December"
                                        ],
                                        monthsOfYearShort: [
                                                "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                                "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
                                        ],
                                        durationLabel: ["Days", "Hours", "Minutes", "Seconds"],
                                        durationDays: ["Day", "Days"],
                                        timeFormat: 24,
                                        headerFormat: "%A, %B %-d, %Y",
                                        tooltip: "Open Date Picker",
                                        nextMonth: "Next Month",
                                        prevMonth: "Previous Month",
                                        dateFieldOrder: ["m", "d", "y"],
                                        timeFieldOrder: ["h", "i", "a"],
                                        slideFieldOrder: ["y", "m", "d"],
                                        dateFormat: "%Y-%m-%d",
                                        useArabicIndic: false,
                                        isRTL: false,
                                        calStartDay: 0,
                                        clearButton: "Clear",
                                        durationOrder: ["d", "h", "i", "s"],
                                        meridiem: ["AM", "PM"],

                                        // 12HR: "%l:%M %p"
                                        // 24HR: "%k:%M" 
                                        timeOutput: "%k:%M", 
                                        durationFormat: "%Dd %DA, %Dl:%DM:%DS",
                                        calDateListLabel: "Other Dates",
                                        calHeaderFormat: "%B %Y"
                                }
                        }
                },
                _enhanceDate: function() {
                        $.extend(this._date.prototype, {
                                copy: function( adjust, override ) {
                                        // Get a modified copy of the date.
                                        // First array - Offset the new date by #  
                                        //    (position determines date part)
                                        // Second array - If non-zero, force the new date by # 
                                        //    (position determines date part)
                                        
                                        adjust = $.extend( [0,0,0,0,0,0,0], adjust );
                                        override = $.extend( [0,0,0,0,0,0,0], override );
                                        return new Date(
                                                ((override[0] > 0 ) ? override[0] : this.get(0) + adjust[0]),
                                                ((override[1] > 0 ) ? override[1] : this.get(1) + adjust[1]),
                                                ((override[2] > 0 ) ? override[2] : this.get(2) + adjust[2]),
                                                ((override[3] > 0 ) ? override[3] : this.get(3) + adjust[3]),
                                                ((override[4] > 0 ) ? override[4] : this.get(4) + adjust[4]),
                                                ((override[5] > 0 ) ? override[5] : this.get(5) + adjust[5]),
                                                ((override[6] > 0 ) ? override[5] : this.get(6) + adjust[6]));
                                },
                                adj: function (type, amount) {
                                        // Adjust the date.  Yes, this is chainable 
                                        if ( typeof amount !== "number" || typeof type !== "number" ) {
                                                throw new Error( "Invalid Arguments" );
                                        }
                                        switch ( type ) {
                                                case 0: this.setD( 0, this.get(0) + amount ); break;
                                                case 1: this.setD( 1, this.get(1) + amount ); break;
                                                case 2: this.setD( 2, this.get(2) + amount ); break;
                                                case 3: amount *= 60;
                                                        /* falls through */
                                                case 4: amount *= 60;
                                                        /* falls through */
                                                case 5: amount *= 1000;
                                                        /* falls through */
                                                case 6: this.setTime( this.getTime() + amount ); break;
                                        }
                                        return this;
                                },
                                setD: function(type, amount) {
                                        // A chainable version of setWhatever() 
                                        switch ( type ) {
                                                case 0: this.setFullYear(amount); break;
                                                case 1: this.setMonth(amount); break;
                                                case 2: this.setDate(amount); break;
                                                case 3: this.setHours(amount); break;
                                                case 4: this.setMinutes(amount); break;
                                                case 5: this.setSeconds(amount); break;
                                                case 6: this.setMilliseconds(amount); break;
                                        }
                                        return this;
                                },
                                get: function(type) {
                                        // Chainable version of get. Also shorter.
                                        switch ( type ) {
                                                case 0: return this.getFullYear();
                                                case 1: return this.getMonth();
                                                case 2: return this.getDate();
                                                case 3: return this.getHours();
                                                case 4: return this.getMinutes();
                                                case 5: return this.getSeconds();
                                                case 6: return this.getMilliseconds();
                                        }
                                        return false;
                                },
                                get12hr: function() {
                                        if ( this.get(3) === 0 ) { return 12; }
                                        if ( this.get(3) < 13 ) { return this.get(3); }
                                        return this.get(3) - 12;
                                },
                                iso: function() {
                                        var arr = [0,0,0], i = 0;
                                        for ( i=0; i < 3; i++ ) {
                                                arr[ i ] = this.get( i );
                                                if ( i === 1 ) { arr[ i ]++; }
                                                if ( arr[i] < 10 ) { arr[ i ] = "0" + String( arr[ i ] ); }
                                        }
                                        return arr.join( "-" );
                                },
                                comp: function () {
                                        return parseInt( this.iso().replace( /-/g, "" ), 10 );
                                },
                                getEpoch: function() {
                                        return Math.floor( this.getTime() / 1000);
                                },
                                getArray: function() {
                                        var arr = [0,0,0,0,0,0], i = 0;
                                        for ( i = 0; i < 6; i++ ) {
                                                arr[i] = this.get(i);
                                        }
                                        return arr;
                                },
                                setFirstDay: function (day) {
                                        // Grabs first valid (day) of current month
                                        this.setD( 2, 1 ).adj( 2, ( day - this.getDay() ) );
                                        if ( this.get( 2 ) > 10 ) { this.adj( 2, 7 ); }
                                        return this;
                                },
                                setDWeek: function (type,num) {
                                        if ( type === 4 ) {
                                                return this.setD(1,0).setD(2,1).setFirstDay(4).adj(2,-3).adj(2,(num-1)*7);
                                        }
                                        return this.setD(1,0).setD(2,1).setFirstDay(type).adj(2,(num-1)*7);
                                },
                                getDWeek: function (type) {
                                        var t1, t2;

                                        switch ( type ) {
                                                case 0:
                                                        t1 = this.copy([0,-1*this.getMonth()]).setFirstDay(0);
                                                        return Math.floor(
                                                                ( this.getTime() - ( t1.getTime() + (
                                                                        ( this.getTimezoneOffset() - t1.getTimezoneOffset() ) * 60000
                                                                ))) / 6048e5 ) + 1;
                                                case 1:
                                                        t1 = this.copy([0,-1*this.getMonth()]).setFirstDay(1);
                                                        return Math.floor(
                                                                ( this.getTime() - ( t1.getTime() + (
                                                                        ( this.getTimezoneOffset() - t1.getTimezoneOffset() ) * 60000
                                                                ))) / 6048e5 ) + 1;
                                                case 4:
                                                        // this line is some bullshit.  but it does work.
                                                        // (trap for dec 29, 30, or 31st being in the new year's week - these
                                                        // are the only 3 that can possibly fall like this)
                                                        if ( this.getMonth() === 11 && this.getDate() > 28 ) { return 1; }

                                                        t1 = this.copy([0,-1*this.getMonth()],true).setFirstDay(4).adj(2,-3);
                                                        t2 = Math.floor(
                                                                ( this.getTime() - ( t1.getTime() + (
                                                                        ( this.getTimezoneOffset() - t1.getTimezoneOffset() ) * 60000
                                                                ))) / 6048e5 ) + 1;

                                                        if ( t2 < 1 ) {
                                                                t1 = this.copy([-1,-1*this.getMonth()]).setFirstDay(4).adj(2,-3);
                                                                return Math.floor((this.getTime() - t1.getTime()) / 6048e5) + 1;
                                                        }
                                                        return t2;
                                                default:
                                                        return 0;
                                        }
                                }
                        });
                },
                _event: function(e, p) {
                        var tmp,
                                w = $( this ).data( "mobile-datebox" );
                        if ( ! e.isPropagationStopped() ) {
                                switch (p.method) {
                                        case "close":
                                                w.close();
                                                break;
                                        case "open":
                                                w.open(); break;
                                        case "set":
                                                if ( typeof p.value === "object" ) {
                                                        w.theDate = p.value;
                                                        w._t( { method: "doset" } );
                                                } else {
                                                        $( this ).val( p.value );
                                                        $( this ).trigger( "change" );
                                                }
                                                break;
                                        case "doset":
                                                tmp = "_" + w.options.mode + "DoSet";
                                                if ( $.isFunction( w[ tmp ] ) ) {
                                                        w[ tmp ].apply( w, [] );
                                                } else {
                                                        w._t( { 
                                                                method: "set",
                                                                value: w._formatter( w.__fmt(), w.theDate ),
                                                                date: w.theDate
                                                        } );
                                                }
                                                break;
                                        case "dooffset":
                                                if ( p.type ) { 
                                                        w._offset( p.type, p.amount, true );
                                                } 
                                                break;
                                        case "dorefresh":
                                                w.refresh();
                                                break;
                                        case "doclear":
                                                $( this ).val( "" ).trigger( "change" );
                                                break;
                                        case "clear":
                                                $( this ).trigger( "change" );
                                                break;
                                }
                        }
                },
                _ord: {
                        "default": function (num) {
                                // Return an ordinal suffix (1st, 2nd, 3rd, etc)
                                var ending = num % 10;
                                if ( ( num > 9 && num < 21 ) || ending > 3 ) { return "th"; }
                                return [ "th", "st", "nd", "rd" ][ ending ];
                        }
                },
                _dur: function(ms) {
                        var dur = [
                                        ms / ( 60*60*1000*24 ),
                                        ms / ( 60*60*1000) % 24,
                                        ms / ( 60*1000) % 60,
                                        ms / ( 1000 ) % 60,
                                ];
                        $.each(dur, function(a,b){
                                dur[a] = parseInt(b, 10);
                        });
                        return dur;
                },
                _gridblk: {
                        g: [0, 0, "a", "b", "c", "d", "e"],
                        b: ["a", "b", "c", "d", "e", "f"]
                },
                __ : function(val) {
                        var o = this.options,
                                lang = o.lang[o.useLang],
                                mode = o[ o.mode + "lang"],
                                oride = "override" + val.charAt(0).toUpperCase() + val.slice(1);

                        if ( typeof o[ oride ] !== "undefined" ) {
                                return o[ oride ]; 
                        }
                        if ( typeof lang[ val ] !== "undefined" ) {
                                return lang[ val ];
                        }
                        if ( ( typeof mode !== "undefined" ) && ( typeof mode[ val ] !== "undefined" ) ) { 
                                return mode[ val ]; 
                        }
                        return o.lang[ "default" ][ val ];
                },
                __fmt: function() {
                        var w = this,
                                o = this.options;

                        if ( typeof w.fmtOver !== "undefined" && w.fmtOver !== false ) {
                                return w.fmtOver;
                        }
                        
                        switch ( o.mode ) {
                                case "timebox":
                                case "timeflipbox":
                                        return w.__( "timeOutput" );
                                case "durationbox":
                                case "durationflipbox":
                                        return w.__( "durationFormat" );
                                default:
                                        return w.__( "dateFormat" );
                        }
                },
                _zPad: function(number, pad) {
                        // Zero pad a number.
                        if ( typeof pad !== "undefined" && pad === "-" ) { return String(number); }
                        return ( number < 10  ? "0" : "" ) + String( number );
                },
                _dRep: function( oper, direction ) {
                        // Digit replacement Indic/Arabic
                        var ch, i, 
                                start = 48,
                                end = 57,
                                adder = 1584,
                                newd = "";

                        if ( direction === -1 ) {
                                start += adder;
                                end += adder;
                                adder = -1584;
                        }
                        for ( i = 0; i < oper.length; i++ ) {
                                ch = oper.charCodeAt( i );
                                if ( ch >= start && ch <= end ) {
                                        newd = newd + String.fromCharCode( ch+adder );
                                } else {
                                        newd = newd + String.fromCharCode( ch );
                                }
                        }
                        return newd;
                },
                _doIndic: function() {
                        var w = this;

                        w.d.intHTML.find( "*" ).each( function() {
                                if ( $( this ).children().length < 1 ) {
                                        $( this ).text( w._dRep( $( this ).text() ) );
                                } else if ( $( this ).hasClass( "ui-datebox-slideday" ) ) {
                                        $( this ).html( w._dRep( $( this ).html() ) );
                                }
                        });
                        w.d.intHTML.find( "input" ).each(function() {
                                $( this ).val( w._dRep( $( this ).val() ) );
                        });
                },
                _parser: {
                        // Custom Parser Definitions.
                        "default": function () { return false; } // Arguments is STR
                },
                _n: function ( val, def ) {
                        // Don't allow negative values, use a default instead
                        return ( val < 0 ) ? def : val;
                },
                _pa: function (arr,date) {
                        // "Clean" a date for use.
                        if ( typeof date === "boolean" ) { 
                                return new this._date( arr[0], arr[1], arr[2], 0, 0, 0, 0 );
                        }
                        return new this._date( 
                                date.get(0),
                                date.get(1),
                                date.get(2),
                                arr[0],
                                arr[1],
                                arr[2],
                                0
                        );
                },
                _makeDate: function ( str ) {
                        // Date Parser
                        var i,  exp_temp, exp_format, grbg,
                                w = this,
                                o = this.options,
                                defVal = this.options.defaultValue,
                                adv = w.__fmt(),
                                exp_input = null,
                                exp_names = [],
                                date = new w._date(),
                                d = { 
                                        year: -1,
                                        mont: -1,
                                        date: -1,
                                        hour: -1,
                                        mins: -1,
                                        secs: -1,
                                        week: false,
                                        wtyp: 4,
                                        wday: false,
                                        yday: false,
                                        meri: 0
                                };
                                
                        str = $.trim( ( ( w.__( "useArabicIndic" ) === true ) ? 
                                        w._dRep( str, -1 ) : 
                                        str 
                                ) );

                        if ( typeof o.mode === "undefined" ) { return date; }
                        if ( typeof w._parser[ o.mode ] !== "undefined" ) { 
                                return w._parser[ o.mode ].apply( w, [ str ] ); 
                        }

                        if ( o.mode === "durationbox" || o.mode === "durationflipbox" ) {
                                adv = adv.replace(/%D([a-z])/gi, function( match, oper ) {
                                        switch ( oper ) {
                                                case "d":
                                                case "l":
                                                case "M":
                                                case "S": return "(" + match + "|[0-9]+)";
                                                default: return ".+?";
                                        }
                                });

                                adv = new RegExp( "^" + adv + "$" );
                                exp_input = adv.exec(str);
                                exp_format = adv.exec(w.__fmt());

                                if ( exp_input === null || exp_input.length !== exp_format.length ) {
                                        if ( typeof defVal === "number" && defVal > 0 ) {
                                                // defaultValue is an integer
                                                return new w._date(
                                                        ( w.initDate.getEpoch() + parseInt( defVal,10 ) ) * 1000
                                                );
                                        }
                                        // No default, use ZERO.
                                        return new w._date( w.initDate.getTime() );
                                }

                                exp_temp = w.initDate.getEpoch();
                                for ( i=1; i<exp_input.length; i++ ) {
                                        grbg = parseInt( exp_input[i], 10);

                                        if ( exp_format[i].match( /^%Dd$/i ) ) { 
                                                exp_temp = exp_temp + ( grbg * 86400 );
                                        }
                                        if ( exp_format[i].match( /^%Dl$/i ) ) { 
                                                exp_temp = exp_temp + ( grbg * 3600 );
                                        }
                                        if ( exp_format[i].match( /^%DM$/i ) ) { 
                                                exp_temp = exp_temp + ( grbg * 60 );
                                        }
                                        if ( exp_format[i].match( /^%DS$/i ) ) { 
                                                exp_temp = exp_temp + ( grbg ); 
                                        }
                                }
                                return new w._date( exp_temp * 1000 );
                        }

                        adv = adv.replace( /%(0|-)*([a-z])/gi, function( match, pad, oper ) {
                                exp_names.push( oper );
                                switch ( oper ) {
                                        case "p":
                                        case "P":
                                        case "b":
                                        case "B": return "(" + match + "|.+?)";
                                        case "H":
                                        case "k":
                                        case "I":
                                        case "l":
                                        case "m":
                                        case "M":
                                        case "S":
                                        case "V":
                                        case "U":
                                        case "u":
                                        case "W":
                                        case "d": 
                                                return "(" + match + "|[0-9]{" + 
                                                        (( pad === "-" ) ? "1," : "" ) + "2})";
                                        case "j": return "(" + match + "|[0-9]{3})";
                                        case "s": return "(" + match + "|[0-9]+)";
                                        case "g":
                                        case "y": return "(" + match + "|[0-9]{2})";
                                        case "E":
                                        case "G":
                                        case "Y": return "(" + match + "|[0-9]{1,4})";
                                        default: exp_names.pop(); return ".+?";
                                }
                        });

                        adv = new RegExp( "^" + adv + "$" );
                        exp_input = adv.exec(str);
                        exp_format = adv.exec(w.__fmt());

                        if ( exp_input === null || exp_input.length !== exp_format.length ) {
                                if ( defVal !== false ) {
                                        switch ( typeof defVal ) {
                                                case "object":
                                                        if ( $.isFunction( defVal.getDay ) ) {
                                                                date = defVal;
                                                        } else {
                                                                if ( defVal.length === 3 ) {
                                                                        date =  w._pa(
                                                                                defVal,
                                                                                ( o.mode.substr(0,4) === "time" ? date : false )
                                                                        );
                                                                }
                                                        } 
                                                        break;
                                                case "number":
                                                        date =  new w._date( defVal * 1000 ); break;
                                                case "string":
                                                        if ( o.mode.substr(0,4) === "time" ) {
                                                                exp_temp = $.extend(
                                                                                [0,0,0],
                                                                                defVal.split( ":" )
                                                                        ).slice( 0, 3 );
                                                                date = w._pa( exp_temp, date ); 
                                                        } else {
                                                                exp_temp = $.extend( 
                                                                                [0,0,0],
                                                                                defVal.split( "-" )
                                                                        ).slice( 0, 3 );
                                                                exp_temp[1]--;
                                                                date = w._pa( exp_temp, false ); 
                                                        } break;
                                        }
                                }
                                if ( isNaN(date.getDate()) ) { date = new w._date(); }
                        } else {
                                for ( i=1; i<exp_input.length; i++ ) {
                                        grbg = parseInt( exp_input[i], 10);
                                        switch ( exp_names[i-1] ) {
                                                case "s": return new w._date( parseInt( exp_input[i], 10 ) * 1000 );
                                                case "Y":
                                                case "G": d.year = grbg; break;
                                                case "E": d.year = grbg - 543; break;
                                                case "y":
                                                case "g":
                                                        if ( o.afterToday || grbg < 38 ) {
                                                                d.year = 2000 + grbg;
                                                        } else {
                                                                d.year = 1900 + grbg;
                                                        } break;
                                                case "m": d.mont = grbg - 1; break;
                                                case "d": d.date = grbg; break;
                                                case "H":
                                                case "k":
                                                case "I":
                                                case "l": d.hour = grbg; break;
                                                case "M": d.mins = grbg; break;
                                                case "S": d.secs = grbg; break;
                                                case "u": d.wday = grbg - 1; break;
                                                case "w": d.wday = grbg; break;
                                                case "j": d.yday = grbg; break;
                                                case "V": d.week = grbg; d.wtyp = 4; break;
                                                case "U": d.week = grbg; d.wtyp = 0; break;
                                                case "W": d.week = grbg; d.wtyp = 1; break;
                                                case "p":
                                                case "P": 
                                                        grbg = new RegExp("^" + exp_input[i] + "$", "i");
                                                        d.meri = ( grbg.test( w.__( "meridiem" )[0] ) ? -1 : 1 );
                                                        break;
                                                case "b":
                                                        exp_temp = $.inArray( exp_input[i], w.__( "monthsOfYearShort" ) );
                                                        if ( exp_temp > -1 ) { d.mont = exp_temp; }
                                                        break;
                                                case "B":
                                                        exp_temp = $.inArray( exp_input[i], w.__( "monthsOfYear" ) );
                                                        if ( exp_temp > -1 ) { d.mont = exp_temp; }
                                                        break;
                                        }
                                }
                                if ( d.meri !== 0 ) {
                                        if ( d.meri === -1 && d.hour === 12 ) { d.hour = 0; }
                                        if ( d.meri === 1 && d.hour !== 12 ) { d.hour = d.hour + 12; }
                                }

                                date = new w._date(
                                        w._n( d.year, 0 ),
                                        w._n( d.mont, 0 ),
                                        w._n( d.date, 1 ),
                                        w._n( d.hour, 0 ),
                                        w._n( d.mins, 0 ),
                                        w._n( d.secs, 0 ),
                                        0
                                );

                                if ( d.year < 100 && d.year !== -1 ) { date.setFullYear(d.year); }

                                if ( ( d.mont > -1 && d.date > -1 ) ||
                                                ( d.hour > -1 && d.mins > -1 && d.secs > -1 ) ) {
                                        return date;
                                }

                                if ( d.week !== false ) {
                                        date.setDWeek( d.wtyp, d.week );
                                        if ( d.date > -1 ) { date.setDate( d.date ); }
                                }
                                if ( d.yday !== false ) { 
                                        date.setD( 1, 0 ).setD( 2, 1 ).adj( 2, ( d.yday - 1 ) );
                                }
                                if ( d.wday !== false ) { 
                                        date.adj( 2 , ( d.wday - date.getDay() ) );
                                }
                        }
                        return date;
                },
                _customformat: {
                        "default": function() { return false; } // Arguments are OPER, DATE
                },
                _formatter: function(format, date) {
                        var w = this,
                                o = this.options, tmp,
                                dur = 0;

                                if ( o.mode.substr( 0, 4 ) === "dura" ) {
                                        dur = w._dur(this.theDate.getTime() - this.initDate.getTime());

                                        if ( ! format.match( /%Dd/ ) ) { dur[1] += (dur[0]*24);}
                                        if ( ! format.match( /%Dl/ ) ) { dur[2] += (dur[1]*60);}
                                        if ( ! format.match( /%DM/ ) ) { dur[3] += (dur[2]*60);}
                                }

                        format = format.replace(/%(D|X|0|-)*([1-9a-zA-Z])/g, function(match, pad, oper) {
                                if ( pad === "X" ) {
                                        if ( typeof w._customformat[o.mode] !== "undefined" ) { 
                                                return w._customformat[o.mode](oper, date, o);
                                        }
                                        return match;
                                }
                                if ( pad === "D" ) {
                                        switch ( oper ) {
                                                case "d": return dur[0];
                                                case "l": return w._zPad(dur[1]);
                                                case "M": return w._zPad(dur[2]);
                                                case "S": return w._zPad(dur[3]);
                                                case "A": return w.__( "durationDays" )[ (( dur[0] === 1 ) ? 0 : 1 ) ];
                                                default: return match;
                                        }
                                }
                                switch ( oper ) {
                                        case "a": // Short Day
                                                return w.__( "daysOfWeekShort" )[ date.getDay() ];
                                        case "A": // Full Day of week
                                                return w.__( "daysOfWeek" )[ date.getDay() ];
                                        case "b": // Short month
                                                return w.__( "monthsOfYearShort" )[ date.getMonth() ];
                                        case "B": // Full month
                                                return w.__( "monthsOfYear" )[ date.getMonth() ];
                                        case "C": // Century
                                                return parseInt(date.getFullYear() / 100);
                                        case "d": // Day of month
                                                return w._zPad( date.getDate(), pad );
                                        case "H": // Hour (01..23)
                                        case "k":
                                                return w._zPad( date.getHours(), pad );
                                        case "I": // Hour (01..12)
                                        case "l":
                                                return w._zPad( date.get12hr(), pad );
                                        case "m": // Month
                                                return w._zPad( date.getMonth()+1, pad );
                                        case "M": // Minutes
                                                return w._zPad( date.getMinutes(), pad );
                                        case "p": // AM/PM (ucase)
                                        case "P": // AM/PM (lcase)
                                                tmp = w.__( "meridiem" )[ ( ( date.get(3) < 12 ) ? 0 : 1 ) ].toUpperCase();
                                                return ( oper === "P" ? tmp.toLowerCase() : tmp );
                                        case "s": // Unix Seconds
                                                return date.getEpoch();
                                        case "S": // Seconds
                                                return w._zPad( date.getSeconds(), pad );
                                        case "u": // Day of week (1-7)
                                                return w._zPad( date.getDay() + 1, pad );
                                        case "w": // Day of week
                                                return date.getDay();
                                        case "y": // Year (2 digit)
                                                return w._zPad(date.getFullYear() % 100);
                                        case "Y": // Year (4 digit)
                                                return date.getFullYear();
                                        case "E": // BE (Buddist Era, 4 Digit)
                                                return date.getFullYear() + 543;
                                        case "V":
                                                return w._zPad( date.getDWeek(4), pad );
                                        case "U":
                                                return w._zPad( date.getDWeek(0), pad );
                                        case "W":
                                                return w._zPad( date.getDWeek(1), pad );
                                        case "o": // Ordinals
                                                if ( typeof w._ord[o.useLang] !== "undefined" ) {
                                                        return w._ord[ o.useLang ]( date.getDate() );
                                                }
                                                return w._ord[ "default" ](date.getDate());
                                        case "j":
                                                tmp = new Date(date.getFullYear(),0,1);
                                                tmp = "000" + String(Math.ceil((date - tmp) / 86400000)+1);
                                                return tmp.slice(-3);
                                        case "G":
                                                tmp = date.getFullYear();
                                                if ( date.getDWeek(4) === 1 && date.getMonth() > 0 ) {
                                                        return tmp + 1;
                                                }
                                                if ( date.getDWeek(4) > 51 && date.getMonth() < 11 ) {
                                                        return tmp - 1;
                                                }
                                                return tmp;
                                        case "g":
                                                tmp = date.getFullYear % 100;
                                                if ( date.getDWeek(4) === 1 && date.getMonth() > 0 ) {
                                                        ++tmp;
                                                }
                                                if ( date.getDWeek(4) > 51 && date.getMonth() < 11 ) {
                                                        --tmp;
                                                }
                                                return w._zpad(tmp);
                                        default:
                                                return match;
                                }
                        });

                        if ( w.__( "useArabicIndic" ) === true ) {
                                format = w._dRep(format);
                        }

                        return format;
                },
                _btwn: function(value, low, high) {
                        return ( value > low && value < high );
                },
                _minStepFix: function() {
                        // Round "extra" minutes when using a stepper.
                        var newMinute = this.theDate.get(4), 
                                mstep = this.options.minuteStep,
                                roundDirection = this.options.minStepRound,
                                remainder = newMinute % mstep;

                        if ( mstep > 1 && remainder > 0 ) {
                                if ( roundDirection < 0 ) {
                                        newMinute = newMinute - remainder;
                                } else if ( roundDirection > 0 ) {
                                        newMinute = newMinute + ( mstep - remainder );
                                } else {
                                        if ( newMinute % mstep < mstep / 2 ) {
                                                newMinute = newMinute - remainder;
                                        } else {
                                                newMinute = newMinute + ( mstep - remainder );
                                        }
                                }
                        this.theDate.setMinutes(newMinute);
                        }
                },
                _offset: function(mode, amount, update) {
                        // Compute a date/time offset.
                        //   update = false to prevent controls refresh
                        var w = this,
                                o = this.options,
                                now = this.theDate,
                                ok = false;

                        mode = ( mode || "" ).toLowerCase();

                        if ( typeof update === "undefined" ) { update = true; }

                        if ( mode !== "a" && 
                                        ( typeof o.rolloverMode[mode] === "undefined" || o.rolloverMode[mode] === true )
                                ) {
                                ok = $.inArray(mode, [ "y", "m", "d", "h", "i", "s" ]);
                        } else {
                                switch(mode) {
                                        case "y": ok = 0; break;
                                        case "m":
                                                if ( w._btwn( now.get(1) + amount, -1, 12 ) ) { ok = 1; }
                                                break;
                                        case "d":
                                                if ( w._btwn( 
                                                                now.get(2) + amount, 
                                                                0, 
                                                                ( 32 - now.copy( [0], [0,0,32,13] ).get(3) + 1 ) 
                                                        )) { ok = 2; }
                                                break;
                                        case "h":
                                                if ( w._btwn( now.get(3) + amount, -1, 24 ) ) { ok = 3; }
                                                break;
                                        case "i":
                                                if ( w._btwn( now.get(4) + amount, -1, 60 ) ) { ok = 4; }
                                                break;
                                        case "s":
                                                if ( w._btwn( now.get(5) + amount, -1, 60 ) ) { ok = 5; }
                                                break;
                                        case "a":
                                                w._offset( "h", ( ( amount > 0 ) ? 1 : -1 ) * 12, false );
                                                break;
                                }
                        }
                        if ( ok !== false ) { w.theDate.adj( ok, amount ); }
                        if ( update === true ) { w.refresh(); }
                        if ( o.useImmediate ) { w._t( { method: "doset" } ); }

                        if ( w.calBackDate !== false ) {
                                w._t( {
                                        method: "displayChange",
                                        selectedDate: w.calBackDate,
                                        shownDate: w.theDate,
                                        thisChange: mode,
                                        thisChangeAmount: amount,
                                });
                        }
                                
                        w._t( {
                                method: "offset",
                                type: mode,
                                amount: amount,
                                newDate: w.theDate
                        } );
                },
                _startOffset: function(date) {
                        var o = this.options;

                        if ( o.startOffsetYears !== false ) {
                                date.adj( 0, o.startOffsetYears );
                        }
                        if ( o.startOffsetMonths !== false ) {
                                date.adj( 1, o.startOffsetMonths );
                        }
                        if ( o.startOffsetDays !== false ) {
                                date.adj( 2, o.startOffsetDays );
                        }
                        return date;
                },
                _destroy: function() {
                        var w = this,
                                o = this.options,
                                button = this.d.wrap.find( "a" );

                        w.d.wrap.removeClass( "ui-input-has-clear" );
                        button.remove();

                        if ( o.lockInput ) {
                                w.d.input.removeAttr( "readonly" );
                        }

                        w.d.input
                                .off( "datebox" )
                                .off( "focus.datebox" )
                                .off( "blur.datebox" )
                                .off( "change.datebox" );
                                
                        $( document )
                                .off( w.drag.eMove )
                                .off( w.drag.eEnd )
                                .off( w.drag.eEndA );
                },
                _create: function() {
                        // Create the widget, called automatically by widget system
                        $( document ).trigger( "dateboxcreate" );

                        var w = this,
                                o = $.extend(
                                        this.options,
                                        this._getLongOptions( this.element ),
                                        this.element.data( "options" )
                                ),
                                thisTheme = ( ( o.theme === false ) ?
                                        $.mobile.getInheritedTheme( this.element ) :
                                        o.theme
                                ),
                                trans = o.useAnimation ? o.transition : "none",
                                d = {
                                        input: this.element,
                                        wrap: this.element.parent(),
                                        mainWrap: $( "<div>", { 
                                                "class": "ui-datebox-container ui-overlay-shadow " + 
                                                        "ui-corner-all ui-datebox-hidden " + trans +
                                                        " ui-body-" + thisTheme
                                                } ).css( "zIndex", o.zindex ),
                                        intHTML: false
                                },
                                evtid = ".datebox" + this.uuid,
                                touch = ( typeof window.ontouchstart !== "undefined" ),
                                drag = {
                                        eStart : (touch ? "touchstart" : "mousedown" ) + evtid,
                                        eMove  : (touch ? "touchmove" : "mousemove" ) + evtid,
                                        eEnd   : (touch ? "touchend" : "mouseup" ) + evtid,
                                        eEndA  : (touch ?
                                                (["mouseup","touchend","touchcanel","touchmove"].join(evtid+" ") + evtid) :
                                                "mouseup" + evtid
                                        ),
                                        move   : false,
                                        start  : false,
                                        end    : false,
                                        pos    : false,
                                        target : false,
                                        delta  : false,
                                        tmp    : false
                                };

                        $.extend(w, {d: d, drag: drag, touch:touch});

                        if ( o.usePlaceholder !== false ) {
                                if ( o.usePlaceholder === true && w._grabLabel() !== "" ) { 
                                        w.d.input.attr( "placeholder", w._grabLabel());
                                }
                                if ( typeof o.usePlaceholder === "string" ) {
                                        w.d.input.attr( "placeholder", o.usePlaceholder );
                                }
                        }

                        o.theme = thisTheme;

                        w.calBackDate = false;
                        w.calDateVisible = true;
                        w.disabled = false;
                        w.runButton = false;
                        w._date = window.Date;
                        w._enhanceDate();
                        w.baseID = w.d.input.attr( "id" );

                        w.initDate = new w._date();
                        w.initDate.setMilliseconds(0);
                        w.theDate = ( o.defaultValue ) ?
                                w._makeDate() :
                                ( (w.d.input.val() !== "" ) ?
                                        w._makeDate( w.d.input.val() ) :
                                        new w._date() );

                        if ( w.d.input.val() === "" ) { w._startOffset( w.theDate ); }

                        w.initDone = false;

                        if ( o.showInitialValue ) {
                                w.d.input.val( w._formatter( w.__fmt(), w.theDate ) );
                        }

                        if ( o.useButton ) {
                                if ( o.mode !== false ) {
                                        w.d.wrap.addClass( "ui-input-has-clear" );
                                        if ( o.buttonIcon === false ) {
                                                if ( o.mode.substr( 0, 4 ) === "time" || o.mode.substr( 0 ,3 ) === "dur" ) {
                                                        o.buttonIcon = o.buttonIconTime;
                                                } else {
                                                        o.buttonIcon = o.buttonIconDate;
                                                }
                                        }
                                        $( "<a href='#' class='ui-input-clear ui-btn ui-icon-" + 
                                                        o.buttonIcon +
                                                        " ui-btn-icon-notext ui-corner-all'></a>" )
                                                .attr( "title", w.__( "tooltip" ) )
                                                .text( w.__( "tooltip" ) )
                                                .appendTo(w.d.wrap)
                                                .on(o.clickEvent, function( e ) {
                                                        e.preventDefault();
                                                        if ( o.useFocus ) {
                                                                w.d.input.focus();
                                                        } else {
                                                                if ( !w.disabled ) { w._t( { method: "open" } ); }
                                                        }
                                                });
                                }
                        }

                        if ( o.hideInput ) { w.d.wrap.hide(); }
                        if ( o.hideContainer ) { w.d.wrap.parent().hide(); }

                        w.d.input
                                .on( "focus.datebox", function(){
                                        w.d.input.addClass( "ui-focus" );
                                        if ( w.disabled === false && o.useFocus ) {
                                                w._t( { method: "open" } );
                                        }
                                })
                                .on( "blur.datebox", function() { 
                                        w.d.input.removeClass( "ui-focus" ); 
                                })
                                .on( "change.datebox", function() {
                                        w.theDate = w._makeDate( w.d.input.val() );
                                        w.refresh();
                                })
                                .on( "datebox", w._event );

                        if ( o.lockInput ) { 
                                w.d.input.attr( "readonly", "readonly" ); 
                        }

                        // Check if mousewheel plugin is loaded
                        if ( typeof $.event.special.mousewheel !== "undefined" ) {
                                w.wheelExists = true;
                        }

                        // Disable when done if element attribute disabled is true.
                        if ( w.d.input.is( ":disabled" ) ) {
                                w.disable();
                        }

                        w.applyMinMax(false, false);

                        if ( o.useInline || o.useInlineBlind ) {
                                w.open();
                        }

                        //Throw dateboxinit event
                        $( document ).trigger( "dateboxaftercreate" );
                },
                applyMinMax: function( refresh, override ) {
                        // PUBLIC function to apply min/max attributes
                        var todayClean, fromEl, fromElDate, daysRaw,
                                w = this,
                                o = this.options,
                                today = new this._date(),
                                lod = 24 * 60 * 60 * 1000;

                        todayClean = w._pa([0,0,0], today);
                        
                        if ( typeof refresh === "undefined" ) { refresh = true; }
                        if ( typeof override === "undefined" ) { override = true; }

                        if ( ( override === true || o.minDays === false ) && 
                                        ( typeof w.d.input.attr( "min" ) !== "undefined" ) ) {

                                fromEl =  w.d.input.attr( "min" ).split( "-" );
                                fromElDate = new w._date(fromEl[0], fromEl[1]-1, fromEl[2], 0, 0, 0, 0 );
                                daysRaw = ( fromElDate.getTime() - todayClean.getTime() ) / lod;
                                o.minDays = parseInt( daysRaw * -1 , 10 ) + 0;
                        }
                        if ( ( override === true || o.maxDays === false ) && 
                                        ( typeof w.d.input.attr( "max" ) !== "undefined" ) ) {

                                fromEl = w.d.input.attr( "max" ).split( "-" );
                                fromElDate = new w._date(fromEl[0], fromEl[1]-1, fromEl[2], 0, 0, 0, 0 );
                                daysRaw = ( fromElDate.getTime() - todayClean.getTime() ) / lod;
                                o.maxDays = parseInt( daysRaw, 10 ) - 1;
                        }

                        if ( refresh === true ) { 
                                w._t( { method: "refresh" } );
                        }
                },
                _build: {
                        "default": function () {
                                this.d.headerText = "Error";
                                if ( this.d.intHTML !== false ) {
                                        this.d.intHTML.remove().empty();
                                }
                                this.d.intHTML = $("<div class='ui-body-b'><h2 style='text-align:center'>" + 
                                        "Unknown Mode</h2></div>" );
                        }
                },
                _drag: {
                        "default": function () { return false; }
                },
                open: function () {
                        // PUBLIC function to open the control
                        var w = this,
                                o = this.options,
                                popopts = {
                                        transition: (o.useAnimation ? o.transition : "none" )
                                },
                                basepop = { 
                                        history: false,
                                        transition: (o.useAnimation ? o.transition : "none" )
                                };

                        if ( o.useFocus && w.fastReopen === true ) { 
                                w.d.input.blur();
                                return false;
                        }

                        w.theDate = w._makeDate( w.d.input.val() );
                        w.calBackDate = false;
                        if ( w.d.input.val() === "" ) { w._startOffset( w.theDate ); }
                        w.d.input.blur();

                        if ( typeof w._build[ o.mode ] === "undefined" ) {
                                w._build[ "default" ].apply( w, [] );
                        } else {
                                w._build[ o.mode ].apply( w, [] );
                        }
                        if ( typeof w._drag[ o.mode ] !== "undefined" ) {
                                w._drag[ o.mode ].apply( w, [] );
                        }

                        w._t( { method: "refresh" } );

                        if ( w.__( "useArabicIndic" ) === true ) { w._doIndic(); }

                        if ( ( o.useInline || o.useInlineBlind ) && w.initDone === false ) {
                                w.d.mainWrap.append( w.d.intHTML );
                                
                                if ( o.hideContainer ) {
                                        if ( o.useHeader ) {
                                                w.d.mainWrap.prepend( $( "<div class='ui-header ui-bar-" + o.themeHeader +
                                                        "'>" + "<h1 class='ui-title'>" + w.d.headerText + "</h1>" + "</div>" )
                                                );
                                        }
                                        w.d.wrap.parent().after( w.d.mainWrap );
                                } else {
                                        w.d.wrap.parent().append( w.d.mainWrap );
                                }
                                w.d.mainWrap.removeClass( "ui-datebox-hidden ui-overlay-shadow" );
                                if ( o.useInline ) {
                                        w.d.mainWrap
                                                .addClass( "ui-datebox-inline" )
                                                .css( "zIndex", "auto" );
                                                
                                        if ( !o.hideInput && !o.hideContainer ) {
                                                w.d.mainWrap.addClass("ui-datebox-inline-has-input");
                                        } 
                                        // This is really hacky.  I hate it, but I don't have a 
                                        // better idea right now.  Cleans up position on flip variants.
                                        setTimeout( (function(w) { 
                                                return function() {
                                                        w._t( { method: "postrefresh" } );
                                                };
                                        }(w)), 100);
                                        return true;
                                } else {
                                        w.d.mainWrap
                                                .addClass( "ui-datebox-inline ui-datebox-inline-has-input" )
                                                .css( "zIndex", "auto" );
                                        w.d.mainWrap.hide();
                                }
                                w.initDone = false;
                                w._t( { method: "postrefresh" } );
                        }

                        if ( o.useInlineBlind ) {
                                if ( w.initDone ) { 
                                        w.refresh();
                                        w.d.mainWrap.slideDown();
                                        w._t( { method: "postrefresh" } );
                                } else { 
                                        w.initDone = true; 
                                }
                                return true;
                        }

                        // Ignore if already open
                        if ( w.d.intHTML.is( ":visible" ) ) { return false; }

                        w.d.mainWrap.empty();

                        if ( o.useHeader ) {
                                w.d.mainWrap.append( $( "<a href='#'>Close</a>" )
                                        .addClass( "ui-btn-left ui-link ui-btn ui-btn-" +
                                                ( ( o.themeCloseButton === false ) ? o.themeHeader : o.themeCloseButton ) +
                                                " ui-icon-delete " + 
                                                "ui-btn-icon-notext ui-shadow ui-corner-all"
                                        )
                                        .on( o.clickEventAlt, function( e ) {
                                                e.preventDefault();
                                                w._t( { method: "close" } );
                                        } )
                                );
                                w.d.mainWrap.append( $( "<div class='ui-header ui-bar-" + o.themeHeader + "'>" + 
                                        "<h1 class='ui-title'>" + w.d.headerText + "</h1>" +
                                        "</div>" )
                                );
                        }
                        
                        w.d.mainWrap.append( w.d.intHTML ).css( "zIndex", o.zindex );
                        w._t( { method: "postrefresh" } );

                        if ( o.popupPosition !== false ) {
                                popopts.positionTo = o.popupPosition;
                        } else {
                                if ( typeof w.baseID !== "undefined" ) {
                                        popopts.positionTo = "#" + w.baseID;
                                } else {
                                        popopts.positionTo = "window";
                                }
                        }

                        if ( o.popupForceX !== false && o.popupForceY !== false ) {
                                popopts.x = parseInt(o.popupForceX,10);
                                popopts.y = parseInt(o.popupForceY,10);
                                popopts.positionTo = "origin";
                        }

                        if ( o.useModal ) {
                                basepop.overlayTheme = o.useModalTheme;
                                basepop.dismissible = false;
                        }

                        // Perpare open callback, if provided. Additionally, if this
                        // returns false then the open/update will stop.
                        if ( o.openCallback !== false ) {
                                if ( ! $.isFunction( o.openCallback ) ) {
                                        if ( typeof window[ o.openCallback ] === "function" ) {
                                                o.openCallback = window[ o.openCallback ];
                                        }
                                }
                                basepop.afteropen = function() {
                                        w._t( { method: "postrefresh" } );
                                        if ( o.openCallback.apply( w, $.merge([{
                                                                custom: w.customCurrent,
                                                                initDate: w.initDate,
                                                                date: w.theDate,
                                                                duration: w.lastDuration
                                                        }], o.openCallbackArgs ) ) === false ) {

                                                w._t( {method: "close"} );
                                        }
                                };
                        } else {
                                basepop.afteropen = function() {
                                        w._t( { method: "postrefresh" } );
                                };
                        }
                        // Prepare close callback.
                        if ( o.closeCallback !== false ) {
                                if ( ! $.isFunction( o.closeCallback ) ) {
                                        if ( typeof window[ o.closeCallback ] === "function" ) {
                                                o.closeCallback = window[ o.closeCallback ];
                                        }
                                }
                                basepop.afterclose = function() {
                                        o.closeCallback.apply( w, $.merge([{
                                                custom: w.customCurrent,
                                                initDate: w.initDate,
                                                date: w.theDate,
                                                duration: w.lastDuration
                                        }], o.closeCallbackArgs ) );
                                };
                        }
                        // Perpare BEFORE open callback, if provided. Additionally, if this
                        // returns false then the open/update will stop.
                        if ( o.beforeOpenCallback !== false ) {
                                if ( ! $.isFunction( o.beforeOpenCallback ) ) {
                                        if ( typeof window[ o.beforeOpenCallback ] === "function" ) {
                                                o.beforeOpenCallback = window[ o.beforeOpenCallback ];
                                        }
                                }
                                if ( o.beforeOpenCallback.apply( w, $.merge([{
                                                custom: w.customCurrent,
                                                initDate: w.initDate,
                                                date: w.theDate,
                                                duration: w.lastDuration
                                        }], o.beforeOpenCallbackArgs ) ) === false ) {
                                                return false;
                                }
                        }

                        w.d.mainWrap
                                .removeClass( "ui-datebox-hidden" )
                                .popup( basepop )
                                .popup( "open", popopts );
                },
                close: function() {
                        // Provide a PUBLIC function to close the element.
                        var w = this,
                                o = this.options;

                        w.calBackDate = false;
                        
                        if ( o.useInlineBlind ) { 
                                // Slide up useInlineBlind
                                w.d.mainWrap.slideUp();
                                return true;
                        }
                        if ( o.useInline || w.d.intHTML === false ) { 
                                // Do nothing for useInline or empty.
                                return true;
                        }

                        // Trigger the popup to close
                        w.d.mainWrap.popup( "close" );

                        // Unbind all drag handlers.
                        $( document )
                                .off( w.drag.eMove )
                                .off( w.drag.eEnd )
                                .off( w.drag.eEndA );

                        if ( o.useFocus ) {
                                w.fastReopen = true;
                                setTimeout( (function( t ) { 
                                        return function () { 
                                                t.fastReopen = false; 
                                        };
                                }( w )), 300 );
                        }
                },
                refresh: function() {
                        // Provide a PUBLIC function to Refresh the element
                        var w = this,
                                o = this.options;
                        
                        if ( typeof w._build[ o.mode ] === "undefined" ) {
                                w._build[ "default" ].apply( w, [] );
                        } else {
                                w._build[ o.mode ].apply( w, [] );
                        }
                        if ( w.__( "useArabicIndic" ) === true ) { 
                                w._doIndic(); 
                        }
                        w.d.mainWrap.append( w.d.intHTML );
                        w._t( {method: "postrefresh"});
                },
                _check: function() {
                        // Check to see if a date is valid.
                        var td, year, month, date, i,
                                w = this,
                                o = this.options,
                                now = this.theDate;

                        w.dateOK = true;
                        if ( typeof o.mode === "undefined") { return true; }

                        if ( o.afterToday ) {
                                td = new w._date();
                                if ( now < td ) { now = td; }
                        }
                        if ( o.beforeToday ) {
                                td = new w._date();
                                if ( now > td ) { now = td; }
                        }
                        if ( o.maxDays !== false ) {
                                td = new w._date();
                                td.adj( 2, o.maxDays );
                                if ( now > td ) { now = td; }
                        }
                        if ( o.minDays !== false ) {
                                td = new w._date();
                                td.adj( 2, -1 * o.minDays );
                                if ( now < td ) { now = td; }
                        }
                        if ( o.minHour !== false ) {
                                if ( now.get(3) < o.minHour ) {
                                        now.setD( 3, o.minHour );
                                }
                        }
                        if ( o.maxHour !== false ) {
                                if ( now.get(3) > o.maxHour ) {
                                        now.setD( 3, o.maxHour );
                                }
                        }
                        if ( o.maxYear !== false ) {
                                td = new w._date( o.maxYear, 11, 31 );
                                if ( now > td ) { now = td; }
                        }
                        if ( o.minYear !== false ) {
                                td = new w._date( o.minYear, 0, 1 );
                                if ( now < td ) { now = td; }
                        }

                        if ( o.mode.substr(0,4) === "time" || o.mode.substr(0,3) === "dur" ) {
                                if ( o.mode === "timeflipbox" && o.validHours !== false ) {
                                        if ( $.inArray( now.get(3), o.validHours ) < 0 ) { w.dateOK = false; }
                                }
                        } else {
                                if ( o.blackDatesRec !== false ) {
                                        year = now.get(0);
                                        month = now.get(1);
                                        date = now.get(2);

                                        for ( i=0; i<o.blackDatesRec.length; i++ ) {
                                                if (
                                                        ( o.blackDatesRec[i][0] === -1 || o.blackDatesRec[i][0] === year ) &&
                                                        ( o.blackDatesRec[i][1] === -1 || o.blackDatesRec[i][1] === month ) &&
                                                        ( o.blackDatesRec[i][2] === -1 || o.blackDatesRec[i][2] === date )
                                                ) { w.dateOK = false; }
                                        }
                                }
                                if ( o.blackDates !== false ) {
                                        if ( $.inArray( now.iso(), o.blackDates ) > -1 ) { 
                                                w.dateOK = false; 
                                        }
                                }
                                if ( o.blackDays !== false ) {
                                        if ( $.inArray( now.getDay(), o.blackDays ) > -1 ) { 
                                                w.dateOK = false; 
                                        }
                                }
                                if ( o.whiteDates !== false ) {
                                        if ( $.inArray( now.iso(), o.whiteDates ) > -1 ) { 
                                                w.dateOK = true; 
                                        }
                                }
                        }
                        w.theDate = now;
                },
                _grabLabel: function() {
                        // Get the most reasonable label for this datebox.
                        // In order of preference - placeholder, title, label for=
                        var inputPlaceholder, inputTitle,
                                w = this,
                                o = this.options,
                                tmp = false;

                        if ( typeof o.overrideDialogLabel === "undefined" ) {
                                inputPlaceholder = w.d.input.attr( "placeholder" );
                                inputTitle = w.d.input.attr( "title" );
                                
                                if ( typeof inputPlaceholder !== "undefined" ) {
                                        return inputPlaceholder;
                                }
                                if ( typeof inputTitle !== "undefined" ) {
                                        return inputTitle;
                                }
                                tmp = $(document).find( "label[for='" + w.d.input.attr( "id" ) + "']" ).text();
                                return ( tmp === "" ) ? false : tmp;
                        }
                        return o.overrideDialogLabel;
                },
                _stdBtn: {
                        clear: function() {
                                var w = this, o = this.options;
                                return $( "<a href='#' role='button'>" + w.__( "clearButton" ) + "</a>" )
                                        .addClass( 
                                                "ui-btn ui-btn-" + o.theme +
                                                " ui-icon-delete ui-btn-icon-left ui-shadow ui-corner-all"
                                        )
                                        .on(o.clickEventAlt, function(e) {
                                                e.preventDefault();
                                                w.d.input.val("");
                                                w._t( { method: "clear" } );
                                                w._t( { method: "close" } );
                                        });
                        },
                        close: function(txt) {
                                var w = this, o = this.options;
                                return $( "<a href='#' role='button'>" + txt + "</a>" )
                                        .addClass( "ui-btn ui-btn-" + o.themeSetButton + 
                                                " ui-icon-check ui-btn-icon-left ui-shadow ui-corner-all" +
                                                ( ( w.dateOK === true ) ? "" : " ui-state-disabled" )
                                        )
                                        .on(o.clickEventAlt, function(e) {
                                                e.preventDefault();
                                                if ( w.dateOK === true ) {
                                                        w._t( { 
                                                                method: "set", 
                                                                value: w._formatter(w.__fmt(),w.theDate),
                                                                date: w.theDate
                                                        } );
                                                        w._t( { method: "close" } );
                                                }
                                                
                                        });
                        }
                },
                _makeEl: function( source, parts ) {
                        // Populate a source element with data parts.
                        var part = false,
                                retty = false;

                        retty = source.clone();

                        if ( typeof parts.attr !== "undefined" ) {
                                for ( part in parts.attr ) {
                                        if ( parts.attr.hasOwnProperty(part) ) {
                                                retty.data(part, parts.attr[part]);
                                        }
                                }
                        }
                        return retty;
                },
                _getLongOptions: function( element ) {
                        // Pull "long" options from the element, i.e.
                        // data-datebox-mode="datebox" --> options.mode
                        var key, temp,
                                returnObj = {},
                                prefix = "datebox",
                                prefixLength = 7;

                        for ( key in element.data() ) {
                                if ( key.substr( 0, prefixLength ) === prefix && key.length > prefixLength ) {
                                        temp = key.substr( prefixLength );
                                        temp = temp.charAt( 0 ).toLowerCase() + temp.slice( 1 );
                                        if ( temp !== "options" ) {
                                                returnObj[ temp ] = element.data( key );
                                        }
                                }
                        }
                        return returnObj;
                },
                disable: function() {
                        var w = this;
                        // Provide a PUBLIC function to Disable the element
                        w.d.input.attr( "disabled", true );
                        w.d.wrap.addClass( "ui-state-disabled" ).blur();
                        w.disabled = true;
                        w.d.mainWrap.addClass( "ui-state-disabled" );
                        w._t( { method: "disable"});
                },
                enable: function() {
                        var w = this;
                        // Provide a PUBLIC function to Enable the element
                        w.d.input.attr( "disabled", false );
                        w.d.wrap.removeClass( "ui-state-disabled" );
                        w.disabled = false;
                        w.d.mainWrap.removeClass( "ui-state-disabled" );
                        w._t( { method: "enable" });
                },
                _setOption: function() {
                        $.Widget.prototype._setOption.apply( this, arguments );
                        this.refresh();
                },
                getTheDate: function() {
                        // Provide a PUBLIC function to get the current date.
                        if ( this.calBackDate !== false ) { return this.calBackDate; }
                        return this.theDate;
                },
                getLastDur: function() {
                        // Provide a PUBLIC function to get the last entered duration
                        return this.lastDuration;
                },
                dateVisible: function() {
                        // Provide a PUBLIC function to see if selected calendar date is visible
                        return this.calDateVisible;
                },
                setTheDate: function( newDate ) {
                        // Provide a PUBLIC function to set the date
                        // ACCEPTS: Date Object or String in proper output format
                        if ( typeof( newDate ) === "object" ) {
                                this.theDate = newDate;
                        } else {
                                this.theDate = this._makeDate( newDate );
                        }
                        this.refresh();
                        this._t( { method: "doset" });
                },
                parseDate: function( format, strdate ) {
                        // Provide a PUBLIC function to parse a date
                        var retty,
                                w = this;
                                
                        w.fmtOver = format;
                        retty = w._makeDate( strdate );
                        w.fmtOver = false;
                        return retty;
                },
                callFormat: function( format, date ) {
                        // Provide a PUBLIC function to get a formatted date
                        return this._formatter( format, date );
                },
                getOption: function( opt ) {
                        // Provide a PUBLIC function to get a defined option or i18n member
                        var i18nTester = this.__(opt);
                        if ( typeof i18nTester !== "undefined" ) {
                                return i18nTester;
                        } else {
                                return this.options[ opt ];
                        }
                },
                _t: function ( obj ) {
                        this.d.input.trigger( "datebox", obj );
                }
        });


})( jQuery );
/*
 * jQuery-Mobile-DateBox 
 * Date: Fri Dec 5 2014 22:49:45 UTC
 * http://dev.jtsage.com/jQM-DateBox/
 * https://github.com/jtsage/jquery-mobile-datebox
 *
 * Copyright 2010, 2014 JTSage. and other contributors
 * Released under the MIT license.
 * https://github.com/jtsage/jquery-mobile-datebox/blob/master/LICENSE.txt
 *
 */


/*! CALBOX Mode */

(function($) {
        $.extend( $.mobile.datebox.prototype.options, {
                themeDateToday: "b",
                themeDayHigh: "b",
                themeDatePick: "b",
                themeDateHigh: "b",
                themeDateHighAlt: "b",
                themeDateHighRec: "b",
                themeDate: "a",
                
                calNextMonthIcon: "plus",
                calPrevMonthIcon: "minus",
                
                calHighToday: true,
                calHighPick: true,
                
                calShowDays: true,
                calOnlyMonth: false,
                calWeekMode: false,
                calWeekModeDay: 1,
                calControlGroup: false,
                calShowWeek: false,
                calUsePickers: false,
                calNoHeader: false,
                calFormatter: false,
                
                calYearPickMin: -6,
                calYearPickMax: 6,
                
                useTodayButton: false,
                useTomorrowButton: false,
                useCollapsedBut: false,
                
                highDays: false,
                highDates: false,
                highDatesRec: false,
                highDatesAlt: false,
                enableDates: false,
                calDateList: false,
                calShowDateList: false
        });
        $.extend( $.mobile.datebox.prototype, {
                _cal_gen: function (start,prev,last,other,month) {
                        var rc = 0, cc = 0, day = 1, 
                                next = 1, cal = [], row = [], stop = false;
                                
                        for ( rc = 0; rc <= 5; rc++ ) {
                                if ( stop === false ) {
                                        row = [];
                                        for ( cc = 0; cc <= 6; cc++ ) {
                                                if ( rc === 0 && cc < start ) {
                                                        if ( other === true ) {
                                                                row.push([prev + (cc - start) + 1,month-1]);
                                                        } else {
                                                                row.push(false);
                                                        }
                                                } else if ( rc > 3 && day > last ) {
                                                        if ( other === true ) {
                                                                row.push([next,month+1]); next++;
                                                        } else {
                                                                row.push(false);
                                                        }
                                                        stop = true;
                                                } else {
                                                        row.push([day,month]); day++;
                                                        if ( day > last ) { stop = true; }
                                                }
                                        }
                                        cal.push(row);
                                }
                        }
                        return cal;
                },
                _cal_check : function (checkDates, year, month, date, done) {
                        var w = this, i,
                                o = this.options,
                                maxDate = done.x,
                                minDate = done.i,
                                thisDate = done.t,
                                presetDay = done.p,
                                day = new this._date(year,month,date,0,0,0,0).getDay(),
                                bdRec = o.blackDatesRec,
                                hdRec = o.highDatesRec,
                                ret = {
                                        ok: true,
                                        iso: year + "-" + w._zPad(month+1) + "-" + w._zPad(date),
                                        theme: o.themeDate,
                                        force: false,
                                        recok: true,
                                        rectheme: false
                                };
                        
                        if ( month === 12 ) { ret.iso = ( year + 1 ) + "-01-" + w._zPad(date); }
                        if ( month === -1 ) { ret.iso = ( year - 1 ) + "-12-" + w._zPad(date); }
                        
                        ret.comp = parseInt( ret.iso.replace( /-/g, "" ), 10 );
                        
                        if ( bdRec !== false ) {
                                for ( i=0; i < bdRec.length; i++ ) {
                                        if ( 
                                                ( bdRec[i][0] === -1 || bdRec[i][0] === year ) &&
                                                ( bdRec[i][1] === -1 || bdRec[i][1] === month ) &&
                                                ( bdRec[i][2] === -1 || bdRec[i][2] === date )
                                        ) { ret.ok = false; } 
                                }
                        }
                        
                        if ( $.isArray( o.enableDates ) && $.inArray( ret.iso, o.enableDates ) < 0 ) {
                                ret.ok = false;
                        } else if ( checkDates ) {
                                if (
                                        ( ret.recok !== true ) ||
                                        ( o.afterToday && thisDate.comp() > ret.comp ) ||
                                        ( o.beforeToday && thisDate.comp() < ret.comp ) ||
                                        ( o.notToday && thisDate.comp() === ret.comp ) ||
                                        ( o.maxDays !== false && maxDate.comp() < ret.comp ) ||
                                        ( o.minDays !== false && minDate.comp() > ret.comp ) ||
                                        ( $.isArray(o.blackDays) && $.inArray(day, o.blackDays) > -1 ) ||
                                        ( $.isArray(o.blackDates) && $.inArray(ret.iso, o.blackDates) > -1 ) 
                                ) {
                                        ret.ok = false;
                                }
                        }

                        if ( $.isArray(o.whiteDates) && $.inArray(ret.iso, o.whiteDates) > -1 ) {
                                ret.ok = true;
                        }

                        if ( ret.ok ) {
                                if ( hdRec !== false ) {
                                        for ( i=0; i < hdRec.length; i++ ) {
                                                if ( 
                                                        ( hdRec[i][0] === -1 || hdRec[i][0] === year ) &&
                                                        ( hdRec[i][1] === -1 || hdRec[i][1] === month ) &&
                                                        ( hdRec[i][2] === -1 || hdRec[i][2] === date )
                                                ) { ret.rectheme = true; } 
                                        }
                                }
                                
                                if ( o.calHighPick && date === presetDay && 
                                                ( w.d.input.val() !== "" || o.defaultValue !== false )) {
                                        ret.theme = o.themeDatePick;
                                } else if ( o.calHighToday && ret.comp === thisDate.comp() ) {
                                        ret.theme = o.themeDateToday;
                                } else if ( o.calHighPick && w.calDateVisible && w.calBackDate !== false &&
                                                w.calBackDate.comp() === ret.comp ) {
                                        ret.theme = o.themeDatePick;
                                        ret.force = true;
                                } else if ( $.isArray(o.highDatesAlt) && 
                                                ($.inArray(ret.iso, o.highDatesAlt) > -1)
                                        ) {
                                        ret.theme = o.themeDateHighAlt;
                                } else if ( $.isArray(o.highDates) && ($.inArray(ret.iso, o.highDates) > -1) ) {
                                        ret.theme = o.themeDateHigh;
                                } else if ( $.isArray(o.highDays) && ($.inArray(day, o.highDays) > -1) ) {
                                        ret.theme = o.themeDayHigh;
                                } else if ( $.isArray(o.highDatesRec) && ret.rectheme === true ) {
                                        ret.theme = o.themeDateHighRec;
                                }
                        }
                        return ret;
                }
        });
        $.extend( $.mobile.datebox.prototype._build, {
                "calbox": function () {
                        var tempVal, pickerControl, calContent, genny, weekdayControl, listControl,
                                row, col, rows, cols, htmlRow, i, prangeS, prangeL, fmtRet, fmtObj,
                                absStartDO, absEndDO,
                                w = this,
                                o = this.options,
                                dList = o.calDateList,
                                uid = "ui-datebox-",
                                curDate = ( ( w.calBackDate !== false && 
                                        w.theDate.get(0) === w.calBackDate.get(0) && 
                                        w.theDate.get(1) === w.calBackDate.get(1) ) ? 
                                                new w._date(w.calBackDate.getTime()) :
                                                w.theDate ),
                                checked = false,
                                checkDatesObj = {},
                                minDate = w.initDate.copy(),
                                maxDate = w.initDate.copy(),
                                cStartDay = (curDate.copy([0],[0,0,1]).getDay() - w.__( "calStartDay" ) + 7) % 7,
                                curMonth = curDate.get(1),
                                curYear = curDate.get(0),
                                curDateArr = curDate.getArray(),
                                presetDate = ( w.d.input.val() === "" ) ?
                                        w._startOffset( w._makeDate( w.d.input.val() ) ) :
                                        w._makeDate( w.d.input.val() ),
                                presetDay = -1,
                                cTodayDate = new w._date(),
                                cTodayDateArr = cTodayDate.getArray(),
                                weekNum = curDate
                                        .copy( [0], [0,0,1] )
                                        .adj( 2, ( -1 * cStartDay ) +( w.__( "calStartDay" ) === 0 ? 1 : 0 ) )
                                        .getDWeek(4),
                                weekModeSel = 0,
                                isTrueMonth = false,
                                isTrueYear = false,
                                cMonthEnd = 32 - w.theDate.copy([0],[0,0,32,13]).getDate(),
                                cPrevMonthEnd = 32 - w.theDate.copy([0,-1],[0,0,32,13]).getDate(),
                                checkDates = ( 
                                                o.afterToday || o.beforeToday || o.notToday || 
                                                o.maxDays || o.minDays || o.blackDays || o.blackDates 
                                        ) ?
                                        true :
                                        false;
        
                        if ( w.calBackDate !== false ) {
                                if ( w.theDate.get(0) === w.calBackDate.get(0) && 
                                        w.theDate.get(1) === w.calBackDate.get(1) ) {
                                                w.theDate = new w._date(w.calBackDate.getTime());
                                                w.calBackDate = false;
                                }
                        }
                                
                        if ( typeof w.d.intHTML !== "boolean" ) { 
                                w.d.intHTML.remove(); 
                                w.d.intHTML = null;
                        }
                        
                        w.d.headerText = ( ( w._grabLabel() !== false ) ? 
                                w._grabLabel() :
                                w.__( "titleDateDialogLabel" )
                        );
                        w.d.intHTML = $( "<span>" );

                        $("<div class='" + uid + "gridheader'><div class='" + uid + "gridlabel'><h4>" +
                                w._formatter( w.__( "calHeaderFormat" ), w.theDate ) +
                                "</h4></div></div>")
                                        .appendTo(w.d.intHTML);
                                
                        // Previous and next month buttons, define booleans to decide if they should do anything
                        $( "<div class='" + uid + "gridplus" + ( w.__( "isRTL" ) ? "-rtl" : "") +
                                        "'><a href='#'>" + w.__( "nextMonth") + "</a></div>" )
                                .prependTo( w.d.intHTML.find( "." + uid + "gridheader" ) )
                                .find( "a" )
                                        .addClass( "ui-btn-inline ui-link ui-btn ui-btn-" + 
                                                o.themeDate + 
                                                " ui-icon-" + o.calNextMonthIcon +
                                                " ui-btn-icon-notext ui-shadow ui-corner-all"
                                        )
                                        .on(o.clickEventAlt, function(e) {
                                                e.preventDefault();
                                                if ( w.calNext ) {
                                                        if ( w.calBackDate === false ) { 
                                                                w.calBackDate = new Date(w.theDate.getTime());
                                                        }
                                                        if ( w.theDate.getDate() > 28 ) { w.theDate.setDate(1); }
                                                        w._offset( "m", 1 );
                                                }
                                });
                        $( "<div class='" + uid + "gridminus" + ( w.__( "isRTL" ) ? "-rtl": "" ) +
                                        "'><a href='#'>" + w.__( "prevMonth") + "</a></div>" )
                                .prependTo( w.d.intHTML.find( "." + uid + "gridheader" ) )
                                .find( "a" )
                                        .addClass( "ui-btn-inline ui-link ui-btn ui-btn-" +
                                                o.themeDate +
                                                " ui-icon-" + o.calPrevMonthIcon +
                                                " ui-btn-icon-notext ui-shadow ui-corner-all"
                                        )
                                        .on(o.clickEventAlt, function(e) {
                                                e.preventDefault();
                                                if ( w.calPrev ) {
                                                        if ( w.calBackDate === false ) { 
                                                                w.calBackDate = new Date(w.theDate.getTime());
                                                        }
                                                        if ( w.theDate.getDate() > 28 ) { 
                                                                w.theDate.setDate(1);
                                                        }
                                                        w._offset( "m", -1 );
                                                }
                                        });
                                
                        if ( o.calNoHeader ) { 
                                if ( o.calUsePickersIcons ) {
                                        w.d.intHTML.find( "." + uid + "gridlabel" ).hide();
                                } else {
                                        w.d.intHTML.find( "." + uid + "gridheader" ).remove();
                                }
                        }
                        
                        w.calNext = true;
                        w.calPrev = true;
                        
                        if ( Math.floor( cTodayDate.comp() / 100 )  === Math.floor( curDate.comp() / 100 ) ) {
                                isTrueMonth = true;
                        }
                        if ( Math.floor( cTodayDate.comp() / 10e3 ) === Math.floor( curDate.comp() / 10e3 ) ) {
                                isTrueYear = true;      
                        }
                        if ( presetDate.comp() === curDate.comp() ) { presetDay = presetDate.get(2); }
                        
                        if ( o.afterToday &&
                                        ( isTrueMonth || ( isTrueYear && cTodayDateArr[1] >= curDateArr[1] ) ) ) {
                                w.calPrev = false; }
                        if ( o.beforeToday &&
                                        ( isTrueMonth || ( isTrueYear && cTodayDateArr[1] <= curDateArr[1] ) ) ) {
                                w.calNext = false; }
                        
                        if ( o.minDays !== false ) {
                                minDate.adj( 2, o.minDays * -1 );
                                tempVal = minDate.getArray();
                                if ( curDateArr[0] === tempVal[0] && curDateArr[1] <= tempVal[1] ) {
                                        w.calPrev = false;
                                }
                        }
                        if ( o.maxDays !== false ) {
                                maxDate.adj( 2, o.maxDays );
                                tempVal = minDate.getArray();
                                if ( curDateArr[0] === tempVal[0] && curDateArr[1] >= tempVal[1] ) {
                                        w.calNext = false;
                                }
                        }
                        
                        if ( o.calUsePickers ) {
                                pickerControl = $("<div>");
                                if ( o.calNoHeader && o.calUsePickersIcons ) {
                                        pickerControl.addClass( "ui-datebox-pickicon" );
                                }
                                
                                pickerControl.i = $("<fieldset>").appendTo(pickerControl);
                                
                                pickerControl.a = $( "<select>" )
                                        .appendTo( pickerControl.i );
                                pickerControl.b = $( "<select>" )
                                        .appendTo( pickerControl.i );
                                
                                for ( i=0; i<=11; i++ ) {
                                        pickerControl.a.append(
                                                $( "<option value='" + i + "'" + 
                                                        ( ( curMonth === i ) ?
                                                                " selected='selected'" :
                                                                ""
                                                        ) + ">" + w.__( "monthsOfYear" )[ i ] + "</option>"
                                                )
                                        );
                                }
                                
                                if ( o.calYearPickMin < 1 ) { 
                                        prangeS = curYear + o.calYearPickMin;
                                } else if ( o.calYearPickMin < 1800 ) {
                                        prangeS = curYear - o.calYearPickMin;
                                } else if ( o.calYearPickMin === "NOW" ) {
                                        prangeS = cTodayDateArr[0];
                                } else {
                                        prangeS = o.calYearPickMin;
                                }
                                
                                if ( o.calYearPickMax < 1800 ) {
                                        prangeL = curYear + o.calYearPickMax;
                                } else if ( o.calYearPickMax === "NOW" ) {
                                        prangeL = cTodayDateArr[0];
                                } else {
                                        prangeL = o.calYearPickMax;
                                }
                                for ( i = prangeS; i <= prangeL; i++ ) {
                                        pickerControl.b.append(
                                                $( "<option value='" + i + "'" + 
                                                        ( ( curYear===i ) ? " selected='selected'" : "" ) +
                                                         ">" + i + "</option>"
                                                )
                                        );
                                }
                        
                                pickerControl.a.on( "change", function () {
                                        if ( w.calBackDate === false ) { 
                                                w.calBackDate = new Date(w.theDate.getTime());
                                        }
                                        w.theDate.setD( 1, $( this ).val() );
                                        if ( w.theDate.get(1) !== parseInt( $( this ).val(), 10 ) ) {
                                                w.theDate.setD( 2, 0 );
                                        }
                                        if ( w.calBackDate !== false ) {
                                                w._t( {
                                                        method: "displayChange",
                                                        selectedDate: w.calBackDate,
                                                        shownDate: w.theDate,
                                                        thisChange: "p",
                                                        thisChangeAmount: null
                                                });
                                        }
                                        w.refresh();
                                });
                                pickerControl.b.on( "change", function () {
                                        if ( w.calBackDate === false ) { 
                                                w.calBackDate = new Date(w.theDate.getTime());
                                        }
                                        w.theDate.setD( 0, $( this ).val() );
                                        if (w.theDate.get(1) !== parseInt( pickerControl.a.val(), 10)) {
                                                w.theDate.setD( 2, 0 );
                                        }
                                        if ( w.calBackDate !== false ) {
                                                w._t( {
                                                        method: "displayChange",
                                                        selectedDate: w.calBackDate,
                                                        shownDate: w.theDate,
                                                        thisChange: "p",
                                                        thisChangeAmount: null
                                                });
                                        }
                                        w.refresh();
                                });
                                
                                pickerControl.i.controlgroup({ mini: true, type: "horizontal" });
                                pickerControl.i.find( "select" ).selectmenu( {
                                        //mini: true,
                                        nativeMenu: true
                                } );
                                pickerControl.i.find( ".ui-controlgroup-controls" ).css({
                                        marginRight: "auto",
                                        marginLeft: "auto",
                                        width: "100%",
                                        display: "table",
                                });
                                pickerControl.i.find( ".ui-select" )
                                        .first().css({ width: "60%" })
                                        .end().last().css({ width: "40%" });

                                if ( o.calNoHeader && o.calUsePickersIcons ) { 
                                        pickerControl.i.css({ padding: "0 10px 5px 10px" });
                                }
                                pickerControl.appendTo( w.d.intHTML );
                        }
                        
                        calContent = $("<div class='" + uid + "grid'>" ).appendTo( w.d.intHTML );
                        
                        if ( o.calShowDays ) {
                                w._cal_days = w.__( "daysOfWeekShort").concat( w.__( "daysOfWeekShort" ) );
                                weekdayControl = $( "<div>", { "class": uid + "gridrow" } ).appendTo( calContent );

                                if ( o.calControlGroup ) { weekdayControl.addClass( uid + "gridrow-last" ); }
                                if ( w.__( "isRTL" ) === true ) { 
                                        weekdayControl.css( "direction", "rtl" );
                                }
                                if ( o.calShowWeek ) { 
                                        $("<div>")
                                                .addClass( uid + "griddate " + uid + "griddate-label" )
                                                .appendTo( weekdayControl );
                                }
                                for ( i=0; i<=6;i++ ) {
                                        $( "<div>" )
                                                .text( w._cal_days[ ( i + w.__( "calStartDay") ) % 7 ] )
                                                .addClass( uid + "griddate " + uid + "griddate-label" )
                                                .appendTo( weekdayControl );
                                }
                        }

                        checkDatesObj = { i: minDate, x: maxDate, t: cTodayDate, p: presetDay };
                        genny = w._cal_gen(
                                cStartDay,
                                cPrevMonthEnd,
                                cMonthEnd,
                                !o.calOnlyMonth,
                                curDate.get(1)
                        );
                        
                        if ( ! $.isFunction( o.calFormatter ) && 
                                o.calFormatter !== false &&
                                $.isFunction( window[ o.calFormatter ] ) ) {
                                        o.calFormatter = window[ o.calFormatter ];
                        }
                        
                        absStartDO = new Date(
                                w.theDate.get(0),
                                genny[0][0][1],
                                genny[0][0][0],
                                0, 0, 0, 0 );
                        absEndDO = new Date(
                                w.theDate.get(0),
                                genny[genny.length-1][6][1],
                                genny[genny.length-1][6][0],
                                0, 0, 0, 0 );
                                
                        if ( w.calBackDate === false ) {
                                w.calDateVisible = true;
                        } else {
                                if ( o.calOnlyMonth ) {
                                        w.calDateVisible = false; 
                                } else {
                                        if ( w.calBackDate.comp() < absStartDO.comp() || 
                                                        w.calBackDate.comp() > absEndDO.comp() ) {
                                                w.calDateVisible = false;
                                        } else {
                                                w.calDateVisible = true;
                                        }
                                }
                        }       
                        
                        for ( row = 0, rows = genny.length; row < rows; row++ ) {
                                htmlRow = $("<div>", { "class": uid + "gridrow" } );
                                if ( w.__( "isRTL" ) ) { htmlRow.css( "direction", "rtl" ); }
                                if ( o.calShowWeek ) {
                                                $("<div>", { "class": uid + "griddate " + uid + "griddate-empty" } )
                                                        .text( "W" + weekNum )
                                                        .css( (o.calControlGroup ? {"float": "left"} : {}) )
                                                        .appendTo( htmlRow );
                                                weekNum++;
                                                if ( weekNum > 52 && typeof(genny[ row + 1 ]) !== "undefined" ) { 
                                                        weekNum = new w._date(
                                                                curDateArr[0],
                                                                curDateArr[1],
                                                                ( w.__( "calStartDay" )===0 ) ? 
                                                                        genny[ row + 1 ][ 1 ][ 0 ] :
                                                                        genny[ row + 1 ][ 0 ][ 0 ],
                                                                0, 0, 0, 0
                                                        ).getDWeek( 4 ); }
                                        }
                                for ( col=0, cols = genny[row].length; col < cols; col++ ) {
                                        if ( o.calWeekMode ) { 
                                                weekModeSel = genny[row][o.calWeekModeDay][0]; 
                                        }
                                        if ( typeof genny[row][col] === "boolean" ) {
                                                $("<div>", { 
                                                        "class": uid + "griddate " + uid + "griddate-empty"
                                                } ).appendTo( htmlRow );
                                        } else {
                                                checked = w._cal_check(
                                                        checkDates,
                                                        curDateArr[0],
                                                        genny[row][col][1],
                                                        genny[row][col][0],
                                                        checkDatesObj
                                                );
                                                if ( genny[row][col][0]) {
                                                        if ( ! $.isFunction(o.calFormatter) ) {
                                                                fmtRet = { text: genny[row][col][0], "class": "" };
                                                        } else {
                                                                fmtObj = {
                                                                        "Year": ( ( genny[row][col][1] > 11 ) ? curYear + 1 : 
                                                                                ( genny[row][col][1] < 0 ) ? curYear - 1 : curYear ),
                                                                        "Month" : ( ( genny[row][col][1] === 12 ) ? 0 : 
                                                                                ( genny[row][col][1] === -1 ) ? 11 : genny[row][col][1] ),
                                                                        "Date" : genny[row][col][0]
                                                                };
                                                                fmtObj.ISO = fmtObj.Year + "-" + 
                                                                        w._zPad(fmtObj.Month + 1) + "-" + 
                                                                        w._zPad(fmtObj.Date);
                                                                fmtObj.Comp = parseInt( fmtObj.ISO.replace( /-/g, "" ), 10 ); 
                                                                fmtObj.dateVisible = w.calDateVisible;
                                                                tempVal = o.calFormatter(fmtObj);
                                                                if ( typeof tempVal !== "object" ) {
                                                                        fmtRet = { text: tempVal, "class": "" };
                                                                } else {
                                                                        fmtRet = {
                                                                                "text": tempVal.text,
                                                                                "class": tempVal["class"]
                                                                        };
                                                                }
                                                        }
                                                        $("<div>")
                                                                .html( fmtRet.text )
                                                                .addClass( uid + "griddate ui-corner-all ui-btn")
                                                                .addClass( ( curMonth === genny[row][col][1] || checked.force ) ?
                                                                        ( "ui-btn-" + checked.theme +
                                                                                ( checked.ok ? "" : " ui-state-disabled" )
                                                                        ) :
                                                                        ( uid + "griddate-empty" )
                                                                )
                                                                .addClass( fmtRet["class"] )
                                                                .css(( curMonth !== genny[row][col][1] && !o.calOnlyMonth ) ?
                                                                        { cursor: "pointer" } :
                                                                        {}
                                                                )
                                                                .data( "date", 
                                                                        ( ( o.calWeekMode ) ?
                                                                                weekModeSel :
                                                                                genny[row][col][0] )
                                                                )
                                                                .data( "enabled", checked.ok)
                                                                .data( "month",
                                                                        genny[ row ][ ( ( o.calWeekMode ) ?
                                                                                        o.calWeekModeDay :
                                                                                        col
                                                                                ) ][1]
                                                                )
                                                                .appendTo( htmlRow );
                                                }
                                        }
                                }
                                if ( o.calControlGroup ) {
                                        htmlRow.controlgroup({type: "horizontal"});
                                }
                                if ( row === rows - 1 ) { htmlRow.addClass( uid + "gridrow-last" ); }
                                htmlRow.appendTo(calContent);
                        }
                        if ( o.calShowWeek ) { 
                                calContent.find( "." + uid + "griddate" ).addClass( uid + "griddate-week" );
                        }
                        
                        if ( o.calShowDateList && dList !== false ) {
                                listControl = $( "<div>" );
                                listControl.a = $( "<select name='pickdate'></select>" ).appendTo(listControl);
                                
                                listControl.a.append("<option value='false' selected='selected'>" +
                                        w.__( "calDateListLabel" ) + "</option>" );

                                for ( i = 0; i < dList.length; i++ ) {
                                        listControl.a.append( 
                                                $( "<option value='" + dList[i][0] + "'>" + dList[i][1] + "</option>" )
                                        );
                                }
                                
                                listControl.a.on( "change", function() {
                                        tempVal = $( this ).val().split( "-" );
                                        w.theDate = new w._date(tempVal[0], tempVal[1]-1, tempVal[2], 0,0,0,0);
                                        w._t( { method: "doset" } );
                                });
                                
                                listControl.find( "select" ).selectmenu( { mini: true, nativeMenu: true } );
                                listControl.appendTo( calContent );
                        }
                        
                        if ( o.useTodayButton || o.useTomorrowButton || o.useClearButton ) {
                                htmlRow = $("<div>", { "class": uid + "controls" } );
                                
                                if ( o.useTodayButton ) {
                                        $( "<a href='#' role='button'>" + w.__( "calTodayButtonLabel" ) + "</a>" )
                                                .appendTo(htmlRow)
                                                .addClass( "ui-btn ui-btn-" + o.theme +
                                                        " ui-icon-navigation ui-btn-icon-left ui-shadow ui-corner-all"
                                                )
                                                .on(o.clickEvent, function(e) {
                                                        e.preventDefault();
                                                        w.theDate = w._pa([0,0,0], new w._date());
                                                        w.calBackDate = false;
                                                        w._t( { method: "doset" } );
                                                });
                                }
                                if ( o.useTomorrowButton ) {
                                        $( "<a href='#' role='button'>" + w.__( "calTomorrowButtonLabel" ) + "</a>" )
                                                .appendTo(htmlRow)
                                                .addClass( "ui-btn ui-btn-" + o.theme + 
                                                        " ui-icon-navigation ui-btn-icon-left ui-shadow ui-corner-all"
                                                )
                                                .on(o.clickEvent, function(e) {
                                                        e.preventDefault();
                                                        w.theDate = w._pa([0,0,0], new w._date()).adj( 2, 1 );
                                                        w.calBackDate = false;
                                                        w._t( { method: "doset" } );
                                                });
                                }
                                if ( o.useClearButton ) {
                                        htmlRow.append(w._stdBtn.clear.apply(w));
                                }
                                if ( o.useCollapsedBut ) {
                                        htmlRow.controlgroup({ type: "horizontal" });
                                        htmlRow.addClass( "ui-datebox-collapse" );
                                } else {
                                        htmlRow.controlgroup();
                                }
                                htmlRow.appendTo( calContent );
                        }
                        
                        w.d.intHTML.on(o.clickEventAlt, "div." + uid + "griddate", function(e) {
                                e.preventDefault();
                                if ( $( this ).data( "enabled" ) ) {
                                        w.calBackDate = false;
                                        w.theDate
                                                .setD( 2, 1 )
                                                .setD( 1, $( this ).jqmData( "month" ) )
                                                .setD( 2, $( this ).data( "date" ) );
                                        w._t( {
                                                method: "set",
                                                value: w._formatter( w.__fmt(),w.theDate ),
                                                date: w.theDate
                                        } );
                                        w._t( { method: "close" } );
                                }
                        });
                        w.d.intHTML
                                .on( "swipeleft", function() { 
                                        if ( w.calNext ) { 
                                                if ( w.calBackDate === false ) { 
                                                        w.calBackDate = new Date(w.theDate.getTime());
                                                } 
                                                w._offset( "m", 1 );
                                        } 
                                } )
                                .on( "swiperight", function() {
                                        if ( w.calPrev ) {
                                                if ( w.calBackDate === false ) { 
                                                        w.calBackDate = new Date(w.theDate.getTime());
                                                } 
                                                w._offset( "m", -1 ); 
                                        }
                                } );
                        
                        if ( w.wheelExists ) { // Mousewheel operations, if plugin is loaded
                                w.d.intHTML.on( "mousewheel", function(e,d) {
                                        e.preventDefault();
                                        if ( d > 0 && w.calNext ) {
                                                if ( w.calBackDate === false ) { 
                                                        w.calBackDate = new Date(w.theDate.getTime());
                                                } 
                                                w.theDate.setD( 2, 1 );
                                                w._offset( "m", 1 );
                                        }
                                        if ( d < 0 && w.calPrev ) {
                                                if ( w.calBackDate === false ) { 
                                                        w.calBackDate = new Date(w.theDate.getTime());
                                                }
                                                w.theDate.setD( 2, 1 );
                                                w._offset( "m", -1 );
                                        }
                                });
                        }
                }
        });
})( jQuery );
/*
 * jQuery-Mobile-DateBox 
 * Date: Fri Dec 5 2014 22:49:45 UTC
 * http://dev.jtsage.com/jQM-DateBox/
 * https://github.com/jtsage/jquery-mobile-datebox
 *
 * Copyright 2010, 2014 JTSage. and other contributors
 * Released under the MIT license.
 * https://github.com/jtsage/jquery-mobile-datebox/blob/master/LICENSE.txt
 *
 */


/*! DATEBOX/TIMEBOX/DURATIONBOX modes */

(function($) {
        $.extend( $.mobile.datebox.prototype.options, {
                themeButton: "a",
                themeInput: "a",
                useSetButton: true,
                validHours: false,
                repButton: true,
                durationStep: 1,
                durationSteppers: {"d": 1, "h": 1, "i": 1, "s": 1}
                
        });
        $.extend( $.mobile.datebox.prototype, {
                _dbox_run: function() {
                        var w = this,
                                g = this.drag,
                                timer = 150;
                                
                        if ( g.cnt > 10 ) { timer = 100; }
                        if ( g.cnt > 30 ) { timer = 50; }
                        if ( g.cnt > 60 ) { timer = 20; }
                        if ( g.cnt > 120 ) { timer = 10; }
                        if ( g.cnt > 240 ) { timer = 3; }
                        
                        g.didRun = true;
                        g.cnt++;
                        
                        w._offset( g.target[0], g.target[1], false );
                        w._dbox_run_update();
                        w.runButton = setTimeout(function() {w._dbox_run();}, timer);
                },
                _dbox_fixstep: function( order ) {
                        // Turn back off steppers when displaying a less precise 
                        // unit in the same control.
                        var step = this.options.durationSteppers,
                                actual = this.options.durationStep;
                        
                        if ( $.inArray( "s", order ) > -1 ) {
                                step.i = 1;
                                step.s = actual;
                        }
                        if ( $.inArray( "i", order ) > -1 ) {
                                step.h = 1;
                                step.s = actual;
                        }
                        if ( $.inArray( "h", order ) > -1 ) {
                                step.d = 1;
                                step.s = actual;
                        }
                },
                _dbox_run_update: function(shortRun) {
                        var w = this,
                                o = this.options,
                                i = w.theDate.getTime() - w.initDate.getTime(),
                                dur = ( o.mode === "durationbox" ? true : false ),
                                cDur = w._dur( i<0 ? 0 : i );

                        if ( i < 0 ) {
                                w.lastDuration = 0;
                                if ( dur ) { w.theDate.setTime( w.initDate.getTime() ); }
                        }
                        
                        if ( dur ) {
                                if ( o.minDur !== false &&
                                                ( w.theDate.getEpoch() - w.initDate.getEpoch() ) < o.minDur ) {
                                        w.theDate = new Date( w.initDate.getTime() + ( o.minDur * 1000 ) );
                                        w.lastDuration = o.minDur;
                                        cDur = w._dur( o.minDur * 1000 );
                                }
                                if ( o.maxDur !== false &&
                                                ( w.theDate.getEpoch() - w.initDate.getEpoch() ) > o.maxDur ) {
                                        w.theDate = new Date( w.initDate.getTime() + ( o.maxDur * 1000 ) );
                                        w.lastDuration = o.maxDur;
                                        cDur = w._dur( o.maxDur * 1000 );
                                }
                        }
                                
                        if ( shortRun !== true && dur !== true ) {
                                w._check();
                        
                                if ( o.mode === "datebox" ) {
                                        w.d.intHTML
                                                .find( ".ui-datebox-header" )
                                                        .find( "h4" )
                                                                .text( w._formatter( w.__( "headerFormat" ), w.theDate ) );
                                }
                                
                                if ( o.useSetButton ) {
                                        if ( w.dateOK === false ) { 
                                                w.setBut.addClass( "ui-state-disabled" );
                                        } else {
                                                w.setBut.removeClass( "ui-state-disabled" );
                                        }
                                }
                        }
                        
                        w.d.divIn.find( "input" ).each(function () {
                                switch ( $(this).data( "field" ) ) {
                                        case "y":
                                                $(this).val(w.theDate.get(0)); break;
                                        case "m":
                                                $(this).val(w.theDate.get(1) + 1); break;
                                        case "d":
                                                $(this).val( ( dur ? cDur[0] : w.theDate.get(2) ) );
                                                break;
                                        case "h":
                                                if ( dur ) {
                                                        $(this).val(cDur[1]);
                                                } else {
                                                        if ( w.__("timeFormat") === 12 ) {
                                                                $(this).val(w.theDate.get12hr());
                                                        } else {
                                                                $(this).val(w.theDate.get(3)); 
                                                        }
                                                }
                                                break;
                                        case "i":
                                                if ( dur ) {
                                                        $(this).val(cDur[2]);
                                                } else {
                                                        $(this).val(w._zPad(w.theDate.get(4)));
                                                } 
                                                break;
                                        case "M":
                                                $(this).val(w.__("monthsOfYearShort")[w.theDate.get(1)]); break;
                                        case "a":
                                                $(this).val(w.__( "meridiem" )[ (w.theDate.get(3) > 11) ? 1 : 0 ] );
                                                break;
                                        case "s":
                                                $(this).val(cDur[3]); break;
                                }
                        });
                        if ( w.__( "useArabicIndic" ) === true ) { w._doIndic(); }
                },
                _dbox_vhour: function (delta) {
                        var w = this,
                                o = this.options, tmp, 
                                closeya = [25,0],
                                closenay = [25,0];
                                
                        if ( o.validHours === false ) { return true; }
                        if ( $.inArray(w.theDate.getHours(), o.validHours) > -1 ) { return true; }
                        
                        tmp = w.theDate.getHours();
                        $.each(o.validHours, function(){
                                if ( ((tmp < this)?1:-1) === delta ) {
                                        if ( closeya[0] > Math.abs(this-tmp) ) {
                                                closeya = [Math.abs(this-tmp),parseInt(this,10)];
                                        }
                                } else {
                                        if ( closenay[0] > Math.abs(this-tmp) ) {
                                                closenay = [Math.abs(this-tmp),parseInt(this,10)];
                                        }
                                }
                        });
                        if ( closeya[1] !== 0 ) { w.theDate.setHours(closeya[1]); }
                        else { w.theDate.setHours(closenay[1]); }
                },
                _dbox_enter: function (item) {
                        var tmp,
                                w = this, 
                                t = 0;
                        
                        if ( item.data( "field" ) === "M" ) {
                                tmp = $.inArray( item.val(), w.__("monthsOfYearShort") );
                                if ( tmp > -1 ) { w.theDate.setMonth( tmp ); }
                        }
                        
                        if ( item.val() !== "" && item.val().toString().search(/^[0-9]+$/) === 0 ) {
                                switch ( item.data( "field" ) ) {
                                        case "y":
                                                w.theDate.setD( 0, parseInt(item.val(),10)); break;
                                        case "m":
                                                w.theDate.setD( 1, parseInt(item.val(),10)-1); break;
                                        case "d":
                                                w.theDate.setD( 2, parseInt(item.val(),10));
                                                t += (60*60*24) * parseInt(item.val(),10);
                                                break;
                                        case "h":
                                                w.theDate.setD( 3, parseInt(item.val(),10));
                                                t += (60*60) * parseInt(item.val(),10);
                                                break;
                                        case "i":
                                                w.theDate.setD( 4, parseInt(item.val(),10));
                                                t += (60) * parseInt(item.val(),10);
                                                break;
                                        case "s":
                                                t += parseInt(item.val(),10); break;
                                }
                        }
                        if ( this.options.mode === "durationbox" ) { 
                                w.theDate.setTime( w.initDate.getTime() + ( t * 1000 ) );
                        }
                        w.refresh();
                }
        });
        $.extend( $.mobile.datebox.prototype._build, {
                "timebox": function () {
                        this._build.datebox.apply(this,[]);
                },
                "durationbox": function () {
                        this._build.datebox.apply(this,[]);
                },
                "datebox": function () {
                        var offAmount, i, y, tmp, 
                                w = this,
                                g = this.drag,
                                o = this.options, 
                                dur = ( o.mode === "durationbox" ? true : false ),
                                cnt = -2,
                                defDurOrder = ["d","h","i","s"],
                                uid = "ui-datebox-",
                                divBase = $( "<div>" ),
                                divPlus = $( "<fieldset>" ),
                                divIn = divBase.clone(),
                                divMinus = divPlus.clone(),
                                divLab = divBase.clone(),
                                inBase = $("<div><input type='text'></div>")
                                        .addClass( "ui-input-text ui-body-" + o.themeInput+ 
                                                " ui-corner-all ui-mini ui-shadow-inset"),
                                butBase = $( "<div></div>" ),
                                butClass = "ui-btn-inline ui-link ui-btn ui-btn-" + o.themeButton +
                                        " ui-btn-icon-notext ui-shadow ui-corner-all";
                        
                        if ( typeof w.d.intHTML !== "boolean" ) {
                                w.d.intHTML.empty().remove();
                        }
                        
                        w.d.headerText = ( ( w._grabLabel() !== false ) ?
                                w._grabLabel() : 
                                ( ( o.mode === "datebox" ) ? 
                                        w.__("titleDateDialogLabel") :
                                        w.__("titleTimeDialogLabel")
                                )
                        );
                        w.d.intHTML = $( "<span>" );
                        
                        w.fldOrder = ( ( o.mode === "datebox" ) ?
                                w.__("dateFieldOrder") :
                                ( ( dur ) ? w.__("durationOrder") : w.__("timeFieldOrder") )
                        );

                        if ( !dur ) {
                                w._check();
                                w._minStepFix();
                                w._dbox_vhour(typeof w._dbox_delta !== "undefined" ? w._dbox_delta : 1 );
                        } else {
                                w.dateOK = true;
                                w._dbox_fixstep(w.fldOrder);
                        }
                        
                        if ( o.mode === "datebox" ) { 
                                $( "<div class='" + uid + "header'><h4>" +
                                                w._formatter( w.__("headerFormat"), w.theDate ) + "</h4></div>")
                                        .appendTo(w.d.intHTML); 
                        }
                        
                        for(i = 0; i < w.fldOrder.length; i++) {
                                tmp = w._gridblk.b[i];
                                if ( dur ) {
                                        offAmount = o.durationSteppers[w.fldOrder[i]];
                                } else {
                                        if ( w.fldOrder[i] === "i" ) { 
                                                offAmount = o.minuteStep; 
                                        } else { 
                                                offAmount = 1;
                                        }
                                }
                                if ( w.fldOrder[i] !== "a" || w.__("timeFormat") === 12 ) {                                     
                                        $("<div>")
                                                .append( (dur) ?
                                                        "<label>" + 
                                                        w.__( "durationLabel" )[ $.inArray( w.fldOrder[i], defDurOrder ) ] +
                                                        "</label>" : 
                                                        "" )
                                                .addClass("ui-block-"+tmp)
                                                .appendTo(divLab);
                                        $("<div>")
                                                .append( w._makeEl(inBase, {"attr": {
                                                        "field": w.fldOrder[i],
                                                        "amount": offAmount
                                                } } ) )
                                                .addClass("ui-block-"+tmp)
                                                .appendTo(divIn)
                                                .find( "input" ).data({
                                                        "field": w.fldOrder[i],
                                                        "amount": offAmount
                                                });
                                        w._makeEl( butBase, {"attr": {
                                                        "field": w.fldOrder[i],
                                                        "amount": offAmount 
                                                } } )
                                                .addClass( uid + "cbut ui-block-" + tmp + " ui-icon-plus " + butClass)
                                                .appendTo( divPlus )
                                                .prepend( (dur) ? "<label>" + w.__("durationLabel")[i] + "</label>" : "" );
                                        w._makeEl( butBase, {"attr": {
                                                        "field": w.fldOrder[i],
                                                        "amount": offAmount  * -1
                                                } } )
                                                .addClass( uid + "cbut ui-block-" + tmp + " ui-icon-minus " + butClass)
                                                .appendTo( divMinus );
                                        cnt++;
                                }
                        }
                        
                        if ( dur ) {
                                divLab
                                        .addClass("ui-datebox-dboxlab ui-grid-"+w._gridblk.b[cnt])
                                        .appendTo(w.d.intHTML);
                        }
                        
                        divPlus
                                .addClass("ui-grid-"+w._gridblk.b[cnt])
                                .appendTo(w.d.intHTML);
                                
                        divIn
                                .addClass("ui-datebox-dboxin ui-grid-"+w._gridblk.b[cnt])
                                .appendTo(w.d.intHTML);
                                
                        divMinus
                                .addClass("ui-grid-"+w._gridblk.b[cnt])
                                .appendTo(w.d.intHTML);
                        
                        w.d.divIn = divIn;
                        w._dbox_run_update(true);
                        
                        if ( w.dateOK !== true ) {
                                divIn.find( "input" ).addClass( "ui-state-disable" );
                        } else {
                                divIn.find( ".ui-state-disable" ).removeClass( "ui-state-disable" );
                        }
                        
                        if ( o.useSetButton || o.useClearButton ) {
                                y = $( "<div>", { "class": uid + "controls" } );
                                
                                if ( o.useSetButton ) {
                                        w.setBut = w._stdBtn.close.apply(
                                                w, [(o.mode==="datebox") ? 
                                                        w.__("setDateButtonLabel") :
                                                        ( dur ) ?
                                                                w.__("setDurationButtonLabel") :
                                                                w.__("setTimeButtonLabel")]
                                        );
                                        w.setBut.appendTo(y);
                                }
                                if ( o.useClearButton ) {
                                        y.append(w._stdBtn.clear.apply(w));
                                }
                                if ( o.useCollapsedBut ) {
                                        y.controlgroup({ type: "horizontal" });
                                        y.addClass("ui-datebox-collapse");
                                } else {
                                        y.controlgroup();
                                }
                                y.appendTo(w.d.intHTML);
                        }
                        
                        if ( ! o.repButton ) {
                                w.d.intHTML.on(o.clickEvent, "."+ uid + "cbut", function(e) {
                                        divIn.find(":focus").blur();
                                        e.preventDefault();
                                        w._dbox_delta = ($(this).data("amount")>1) ? 1 : -1;
                                        w._offset($(this).data("field"), $(this).data("amount"));
                                });
                        }
                        
                        divIn.on("change", "input", function() { w._dbox_enter($(this)); });
                                        
                        if ( w.wheelExists ) { // Mousewheel operation, if plugin is loaded
                                divIn.on("mousewheel", "input", function(e,d) {
                                        e.preventDefault();
                                        w._dbox_delta = d<0?-1:1;
                                        w._offset($(this).data("field"), ((d<0)?-1:1)*$(this).data("amount"));
                                });
                        }
                        
                        if ( o.repButton ) {
                                w.d.intHTML.on(g.eStart, "."+ uid + "cbut", function() {
                                        divIn.find(":focus").blur();
                                        tmp = [$(this).data("field"), $(this).data("amount")];
                                        g.move = true;
                                        g.cnt = 0;
                                        w._dbox_delta = ($(this).data("amount")>1) ? 1 : -1;
                                        w._offset(tmp[0], tmp[1], false);
                                        w._dbox_run_update();
                                        if ( !w.runButton ) {
                                                g.target = tmp;
                                                w.runButton = setTimeout(function() {w._dbox_run();}, 500);
                                        }
                                });
                                w.d.intHTML.on(g.eEndA, "." + uid + "cbut", function(e) {
                                        if ( g.move ) {
                                                e.preventDefault();
                                                clearTimeout(w.runButton);
                                                w.runButton = false;
                                                g.move = false;
                                        }
                                });
                        }
                }
        });
})( jQuery );
/*
 * jQuery-Mobile-DateBox 
 * Date: Wed Nov 19 2014 21:05:33 UTC
 * http://dev.jtsage.com/jQM-DateBox/
 * https://github.com/jtsage/jquery-mobile-datebox
 *
 * Copyright 2010, 2014 JTSage. and other contributors
 * Released under the MIT license.
 * https://github.com/jtsage/jquery-mobile-datebox/blob/master/LICENSE.txt
 *
 */
jQuery.extend(jQuery.mobile.datebox.prototype.options.lang, { "en": {
        "setDateButtonLabel": "Set Date",
        "setTimeButtonLabel": "Set Time",
        "setDurationButtonLabel": "Set Duration",
        "calTodayButtonLabel": "Jump to Today",
        "titleDateDialogLabel": "Choose Date",
        "titleTimeDialogLabel": "Choose Time",
        "daysOfWeek": [
                "Sunday",
                "Monday",
                "Tuesday",
                "Wednesday",
                "Thursday",
                "Friday",
                "Saturday"
        ],
        "daysOfWeekShort": [
                "Su",
                "Mo",
                "Tu",
                "We",
                "Th",
                "Fr",
                "Sa"
        ],
        "monthsOfYear": [
                "January",
                "February",
                "March",
                "April",
                "May",
                "June",
                "July",
                "August",
                "September",
                "October",
                "November",
                "December"
        ],
        "monthsOfYearShort": [
                "Jan",
                "Feb",
                "Mar",
                "Apr",
                "May",
                "Jun",
                "Jul",
                "Aug",
                "Sep",
                "Oct",
                "Nov",
                "Dec"
        ],
        "durationLabel": [
                "Days",
                "Hours",
                "Minutes",
                "Seconds"
        ],
        "durationDays": [
                "Day",
                "Days"
        ],
        "tooltip": "Open Date Picker",
        "nextMonth": "Next Month",
        "prevMonth": "Previous Month",
        "timeFormat": 12,
        "headerFormat": "%A, %B %-d, %Y",
        "dateFieldOrder": [
                "m",
                "d",
                "y"
        ],
        "timeFieldOrder": [
                "h",
                "i",
                "a"
        ],
        "slideFieldOrder": [
                "y",
                "m",
                "d"
        ],
        "dateFormat": "%-m/%-d/%Y",
        "useArabicIndic": false,
        "isRTL": false,
        "calStartDay": 0,
        "clearButton": "Clear",
        "durationOrder": [
                "d",
                "h",
                "i",
                "s"
        ],
        "meridiem": [
                "AM",
                "PM"
        ],
        "timeOutput": "%l:%M %p",
        "durationFormat": "%Dd %DA, %Dl:%DM:%DS",
        "calDateListLabel": "Other Dates",
        "calHeaderFormat": "%B %Y",
        "calTomorrowButtonLabel": "Jump to Tomorrow"
}});
jQuery.extend(jQuery.mobile.datebox.prototype.options, {
        useLang: "en"
});
