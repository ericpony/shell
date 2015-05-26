YUI.add("srp-universal-header-uh3", function(a) {
    a.Search.UniversalHeader = {init: function(b) {
            a.Get.script(b.js, {onSuccess: function() {
                    a.once("ucs:helpMenuShow", function() {
                        var e = new a.EventTarget();
                        e.publish("ucs:helpMenuItems", {broadcast: 2,emitFacade: true});
                        var f = [], c = 0;
                        f[c] = [];
                        for (var d = 0; d < b.menu.length; d++) {
                            if (!b.menu[d].title) {
                                c++;
                                f[c] = []
                            } else {
                                f[c].push({menuText: b.menu[d].title,actionType: "link",url: b.menu[d].link,target: "_top"})
                            }
                        }
                        e.fire("ucs:helpMenuItems", {menuGroups: f})
                    })
                }})
        }}
}, "1.0.0", {requires: ["node"]}); /*
YUI 3.10.0 (build a03ce0e)
Copyright 2013 Yahoo! Inc. All rights reserved.
Licensed under the BSD License.
http://yuilibrary.com/license/
*/

YUI.add("substitute", function(e, t) {
    var n = e.Lang, r = "dump", i = " ", s = "{", o = "}", u = /(~-(\d+)-~)/g, a = /\{LBRACE\}/g, f = /\{RBRACE\}/g, l = function(t, l, c, h) {
        var p, d, v, m, g, y, b = [], w, E, S = t.length;
        for (; ; ) {
            p = t.lastIndexOf(s, S);
            if (p < 0)
                break;
            d = t.indexOf(o, p);
            if (p + 1 >= d)
                break;
            w = t.substring(p + 1, d), m = w, y = null, v = m.indexOf(i), v > -1 && (y = m.substring(v + 1), m = m.substring(0, v)), g = l[m], c && (g = c(m, g, y)), n.isObject(g) ? e.dump ? n.isArray(g) ? g = e.dump(g, parseInt(y, 10)) : (y = y || "", E = y.indexOf(r), E > -1 && (y = y.substring(4)), g.toString === Object.prototype.toString || E > -1 ? g = e.dump(g, parseInt(y, 10)) : g = g.toString()) : g = g.toString() : n.isUndefined(g) && (g = "~-" + b.length + "-~", b.push(w)), t = t.substring(0, p) + g + t.substring(d + 1), h || (S = p - 1)
        }
        return t.replace(u, function(e, t, n) {
            return s + b[parseInt(n, 10)] + o
        }).replace(a, s).replace(f, o)
    };
    e.substitute = l, n.substitute = l
}, "3.10.0", {requires: ["yui-base"],optional: ["dump"]});
YUI.add("event-to-load", function(e) {
    var c = e.namespace("Search.EventTL"), a = {timeout: 1000,className: "etl"}, d = {}, g = function(h) {
        e.Search.SRP.beacon(h)
    }, b = function(k, i, h, j) {
        e.Get.js(i, {onSuccess: function(l) {
                d[i] = true;
                k.simulate("click")
            },timeout: j,onTimeout: function(l) {
                e.Get.abort(l);
                e.config.win.location.href = h
            }})
    }, f = function(l) {
        var m = l.currentTarget, j = m.getData(), h = m.getAttribute("href"), i = j.url, k = j.timeout || a.timeout;
        if (!d[i]) {
            l.preventDefault();
            b(m, i, h, k)
        } else {
            g(h)
        }
    };
    e.mix(c, {init: function(h) {
            var i = h.className || a.className;
            e.one("#doc").delegate("click", f, "." + i)
        }})
}, "1.0.0", {requires: ["get", "event", "node"]});
YUI.add("cosmos-soundmark", function(d) {
    var j = d.namespace("Search");
    var k = document.createElement("audio");
    function i() {
        var t = -1;
        if (navigator.appName == "Microsoft Internet Explorer") {
            var r = navigator.userAgent;
            var s = new RegExp("MSIE ([0-9]{1,}[.0-9]{0,})");
            if (s.exec(r) != null) {
                t = parseFloat(RegExp.$1)
            }
        }
        return t
    }
    function m() {
        var r = i();
        if (r > -1) {
            if (r <= 8) {
                return true
            }
        }
        return false
    }
    function b() {
        var x = d.one("#inlineLink");
        if (!x) {
            return
        }
        var t = x.ancestor(".stxt");
        if (!t) {
            return
        }
        var w = x.get("innerHTML").split("|");
        x.remove();
        var y = "";
        var v = {};
        v["#variation"] = w[0];
        v["#synonyms"] = w[1];
        v["#antonyms"] = w[2];
        v["#phrase"] = w[3];
        v["#usage"] = w[4];
        var u = true;
        for (var s in v) {
            if (d.one(s)) {
                if (!u) {
                    y += "   "
                }
                y += '<span><a href="' + s + '" style="margin-right: 10px;" class="fz-s" id="pageLink">' + v[s] + "</a></span>";
                u = false
            }
        }
        var r = d.Node.create(y);
        t.append(r)
    }
    function n() {
        var r = d.one(".searchCenterMiddle");
        if (r) {
            r.setStyle("overflow", "visible")
        }
    }
    function a(s) {
        var r = '<span class="sprt logo" style="background-image: ' + s.image_sprite + "; background-position: " + s.position + "; width: " + s.width + "; height: " + s.height + '; background-repeat: no-repeat; vertical-align: top; display: inline-block; text-align: right; font-size: 13px; "></span>';
        return d.Node.create(r)
    }
    function q() {
        var r = d.one("#iconStyle");
        if (!r) {
            return null
        }
        var s = JSON.parse(r.get("innerHTML"));
        r.remove();
        return s
    }
    function c(r) {
        var s = "";
        switch (r.src[0]) {
            case "Dr.eye":
            case "Dr.eye Phrase":
                s = "http://yun.dreye.com/ews/index_dict.php";
                break;
            default:
                if (r.intl === "us") {
                    s = "https://help.yahoo.com/kb/search/SLN9032.html?impressions=true"
                } else {
                    s = "https://" + r.intl + ".help.yahoo.com/kb/search/SLN9032.html?impressions=true"
                }
        }
        return s
    }
    function l(r, s) {
        return d.Node.create('<a href="' + c(r) + '" class="article_source" target="_blank">' + s + "</a>")
    }
    function f(u) {
        var v = d.one(".searchCenterMiddle .DictionaryResults .compTitle");
        if (!v) {
            return
        }
        var w = d.Node.create('<div id="provider"></div>');
        var s = a(u);
        var t = l(u, u.source[0]);
        var r = d.one(".searchCenterMiddle .DictionaryResults .compTitle .title");
        v.insertBefore(w, r);
        if (u.src[0] === "longman") {
            w.append(t);
            w.append(d.Node.create("<BR/>"));
            var x = l(u, "");
            x.append(s);
            w.append(x);
            x.setStyle("float", "right")
        } else {
            w.append(s);
            w.append(t)
        }
        v.setStyle("margin-bottom", "5px");
        w.setStyle("float", "right");
        w.setStyle("margin-top", "5px");
        t.setStyle("text-align", "right");
        t.setStyle("font-size", "11px");
        if (u.intl === "us") {
            t.setStyle("color", "#bca1d2")
        } else {
            t.setStyle("color", "#a0a0a0")
        }
    }
    function o(r) {
        if (r === undefined || r === null) {
            return false
        }
        return r !== ""
    }
    function g(t) {
        var v = d.Node.create('<span id="proun_sound"></span>');
        if (o(t.sound_type_1[0])) {
            var s = e(t.sound_type_1[0], t.sound_url_1[0], true);
            s.setStyle("vertical-align", "text-bottom");
            if (o(t.sound_type_2[0])) {
                var r = p(t.sound_type_1[0], true);
                s.append(r);
                v.append(s);
                var w = e(t.sound_type_2[0], t.sound_url_2[0], false);
                w.setStyle("vertical-align", "text-bottom");
                var u = p(t.sound_type_2[0], false);
                w.append(u);
                v.append(w)
            } else {
                v.append(s)
            }
        }
        var x = d.one("#pronunciation_pos");
        if (x !== null) {
            x.ancestor().append(v)
        } else {
            d.one("#term").ancestor().append(v)
        }
    }
    function e(r, u, t) {
        var v = '<a href="#" class="sound-' + r.toLowerCase() + ' play-button" ult="{"slk":"audio","pos":1,"sclabel":"audio","sec":"sc","colo":"tw1","vtid":""}"></a>';
        var s = d.Node.create(v);
        s.setStyle("background-image", "url(http://l.yimg.com/pv/i/all/vertical/dictionary/tw_srp_metro_dictionary_201404171929.png)");
        s.setStyle("background-position", "-12px -282px");
        s.setStyle("width", "18px");
        s.setStyle("margin-right", "20px");
        s.setStyle("height", "17px");
        s.setStyle("display", "inline-block");
        if (t) {
            s.setStyle("margin-left", "20px")
        }
        s.on("mouseenter", function() {
            this.setStyle("background-position", "-12px -264px")
        });
        s.on("mouseleave", function() {
            this.setStyle("background-position", "-12px -282px")
        });
        s.on("click", function(w) {
            w.preventDefault();
            w.stopPropagation();
            if (k.getAttribute("src") !== u.mp3) {
                k.setAttribute("src", u.mp3)
            }
            k.play()
        });
        return s
    }
    function p(s) {
        s = s.toLowerCase();
        var t = '<span class="sound-flag sound-flag-' + s + '"></span>';
        var r = d.Node.create(t);
        r.setStyle("background-image", "url(http://l.yimg.com/pv/i/all/vertical/dictionary/tw_srp_metro_dictionary_201404171929.png)");
        if (s === "american") {
            r.setStyle("background-position", "-10px -250px")
        } else {
            r.setStyle("background-position", "-10px -228px")
        }
        r.setStyle("display", "inline-block");
        r.setStyle("margin-left", "20px");
        r.setStyle("margin-top", "3px");
        r.setStyle("width", "10px");
        r.setStyle("height", "17px");
        return r
    }
    function h(t) {
        var r = d.all(".otherTitle");
        var s = 1;
        r.each(function(w) {
            if (!o(t.sound_type_1[s])) {
                s++;
                return true
            }
            var u = e(t.sound_type_1[s], t.sound_url_1[s], false);
            u.setStyle("margin-left", "5px");
            u.setStyle("margin-right", "20px");
            u.setStyle("vertical-align", "text-bottom");
            w.ancestor().append(u);
            if (!o(t.sound_type_2[s])) {
                s++;
                return true
            }
            var v = "background-image: url(http://l.yimg.com/pv/i/all/vertical/dictionary/tw_srp_metro_dictionary_201404171929.png);visibility: visible;width: 10px;height: 14px;display: inline-block;margin-left: 20px;vertical-align: bottom;";
            u.append(d.Node.create('<span style="' + v + 'background-position: -10px -250px; "></span>'));
            u = e(t.sound_type_2[s], t.sound_url_2[s], false);
            u.setStyle("margin-right", "20px");
            u.setStyle("vertical-align", "text-bottom");
            w.ancestor().append(u);
            u.append(d.Node.create('<span style="' + v + 'background-position: -10px -228px; "></span>'));
            s++
        })
    }
    d.Search.Soundmark = {init: function(t) {
            var r = d.one(".DictionaryZRP");
            if (r) {
                return
            }
            n();
            var s = q();
            b();
            if ((s.device !== "phone") && ((s.offset !== "0" && s.docid !== "") || (s.offset === "0"))) {
                f(s)
            }
            if (m()) {
                return
            }
            g(s);
            h(s)
        }}
}, "1.0.0", {requires: ["base", "event-mouseenter", "node"]});
YUI.add("cosmos-compJsToggle", function(f) {
    var a = f.Search.SRP, c = [], e = function(o, n) {
        var l = o.item(0), j, i, k, m;
        if (l) {
            j = l.ancestor();
            i = j.get("offsetHeight");
            j.setStyle("overflow", "hidden").setStyle("height", i);
            o.removeClass("hidden");
            k = j.get("scrollHeight");
            m = new f.Anim({node: j,to: {height: k},duration: n,easing: f.Easing.easeOut,on: {end: function() {
                        j.setStyle("height", "").setStyle("overflow", "")
                    }}});
            m.run()
        }
    }, d = function(o, m, n) {
        var k = o.item(n), i, j, l;
        if (k) {
            i = k.ancestor();
            if (n) {
                j = k.getY()
            } else {
                j = k.getY() - i.getY()
            }
            l = new f.Anim({node: i,to: {height: j},duration: m,easing: f.Easing.easeOut,on: {start: function() {
                        i.setStyle("overflow", "hidden")
                    },end: function() {
                        if (n) {
                            o.each(function(q, p) {
                                if (p >= n) {
                                    q.addClass("hidden")
                                }
                            })
                        } else {
                            o.addClass("hidden")
                        }
                        i.setStyle("height", "").setStyle("overflow", "")
                    }}});
            l.run()
        }
    }, h = function(j, i) {
        j.expand = false;
        if (j.duration) {
            d(i, j.duration, j.offset)
        } else {
            if (j.offset > 0) {
                i.each(function(l, k) {
                    if (k >= j.offset) {
                        l.addClass("hidden")
                    }
                })
            } else {
                i.addClass("hidden")
            }
        }
    }, g = function(k, j, l) {
        if (j && j.size() == 1) {
            var i = k.enableRepositionX ? parseInt(k.enableRepositionX) : 0;
            var m = k.enableRepositionY ? parseInt(k.enableRepositionY) : 0;
            l.some(function(n) {
                if (!n.hasClass("hidden")) {
                    j.item(0).setStyle("position", "absolute").setXY([n.getX() + i, n.getY() + m]);
                    return
                }
            })
        }
    };
    function b() {
        b.superclass.constructor.apply(this, arguments)
    }
    b.NS = "CosmosPlugin";
    b.NAME = "compJsToggle";
    b.ATTRS = {trigger: {value: ""},target: {value: ""},expand: {value: false},action: {value: "click"},offset: {getter: function(i) {
                if (i) {
                    return +i
                }
                return 0
            }},duration: {getter: function(i) {
                if (i) {
                    return +i
                }
                return 0
            }},toggleType: {value: "toggle"},toggleHidden: {value: ""},targetImgLazy: {value: false},targetImgNode: {value: ""},collapseOnOutsideClick: {value: false},enableReposition: {value: false},enableRepositionX: {value: ""},enableRepositionY: {value: ""}};
    f.extend(b, f.Plugin.Base, {initializer: function(i) {
            var k = i.host, j = this.get("trigger"), n = this.get("target"), l = this.get("action"), m = this.get("toggleType"), p = k.all(j), o = k.all(n), q = k.get("id");
            if (p.size() && o.size()) {
                i.duration = this.get("duration");
                i.offset = this.get("offset");
                i.expand = this.get("expand");
                i.toggleHidden = this.get("toggleHidden");
                i.targetImgLazy = this.get("targetImgLazy");
                i.targetImgNode = this.get("targetImgNode");
                i.enableReposition = this.get("enableReposition");
                i.enableRepositionX = this.get("enableRepositionX");
                i.enableRepositionY = this.get("enableRepositionY");
                i.collapseOnOutsideClick = this.get("collapseOnOutsideClick");
                c[q] = i;
                if (i.showTrigger) {
                    p.item(0).ancestor().removeClass("hidden")
                }
                if (i.disableRtClk) {
                    k.delegate("contextmenu", this._disableRtClk, j)
                }
                if (m === "expand") {
                    k.delegate(l, this._expand, j);
                    if (i.collapseOnOutsideClick === "true") {
                        o.on("clickoutside", function(r) {
                            if (i.expand === true) {
                                p.each(function(t, s) {
                                    if (!t.hasClass("hidden")) {
                                        t.simulate("click")
                                    }
                                })
                            }
                        })
                    }
                    if (i.enableReposition === "true") {
                        f.on("windowresize", function(r) {
                            g(i, o, p)
                        })
                    }
                } else {
                    k.delegate(l, this._toggle, j);
                    if (i.dfltState) {
                        k.delegate("mouseleave", this._default, j)
                    }
                }
            }
        },_disableRtClk: function(i) {
            i.halt()
        },_toggle: function(p) {
            var j, i, n, l, o, m, k;
            p.halt();
            if (p.currentTarget.hasClass("selected")) {
                return
            }
            n = p.container.get("id");
            l = c[n];
            if (l) {
                m = l.host.all(l.trigger);
                k = l.host.all(l.target);
                m.removeClass("selected");
                p.currentTarget.addClass("selected");
                i = m.indexOf(p.currentTarget);
                o = k.item(i + parseInt(l.offset, 0));
                if (o) {
                    k.removeClass("selected");
                    o.addClass("selected");
                    if (l.toggleHidden == "true") {
                        k.addClass("hidden");
                        o.removeClass("hidden")
                    }
                }
            }
            j = p.currentTarget.getAttribute("data-beacon");
            if (j) {
                a.beacon(j)
            }
        },_default: function(n) {
            var l, m, j, k, i;
            l = n.container.get("id");
            j = c[l];
            if (j) {
                k = j.host.all(j.trigger);
                i = j.host.all(j.target);
                k.removeClass("selected");
                i.removeClass("selected");
                m = i.item(j.offset - 1);
                if (m) {
                    m.addClass("selected")
                }
            }
        },_expand: function(n) {
            var i, m, k, l, j;
            n.halt();
            m = n.container.get("id");
            k = c[m];
            if (k) {
                l = k.host.all(k.trigger);
                j = k.host.all(k.target);
                if (k.expand === false) {
                    k.expand = true;
                    if (k.targetImgLazy && k.host.all(k.targetImgNode)) {
                        k.host.all(k.targetImgNode).each(function(o) {
                            if (o.getAttribute("data-js-src")) {
                                o.setAttribute("src", o.getAttribute("data-js-src"));
                                o.removeClass("hidden");
                                o.removeAttribute("data-js-src")
                            }
                        })
                    }
                    if (k.duration) {
                        e(j, k.duration)
                    } else {
                        j.removeClass("hidden");
                        if (k.enableReposition === "true") {
                            g(k, j, l)
                        }
                        if (k.cssClassforTriggered) {
                            l.addClass(k.cssClassforTriggered)
                        }
                    }
                } else {
                    h(k, j)
                }
                if (l.size() > 1) {
                    l.removeClass("hidden");
                    n.currentTarget.addClass("hidden")
                }
                i = n.currentTarget.getAttribute("data-beacon");
                if (i) {
                    a.beacon(i)
                }
            }
        }});
    f.namespace("CosmosPlugin").compJsToggle = b
}, "0.0.1", {requires: ["plugin", "event-mouseenter", "anim", "srp-lazy"]});
YUI.add("clickable-background", function(d) {
    var g = d.namespace("Search"), f = null, b = {}, i = 0;
    function j(n) {
        var m, o = n.currentTarget || n.srcElement, l = n.target || n.srcElement;
        m = c(o);
        if (g.SRP && m && !a(l, m)) {
            g.SRP.handleBTrack(n)
        }
        return true
    }
    function h(n) {
        var o, m, l;
        o = n.currentTarget || n.srcElement, el = n.target || n.srcElement;
        m = c(o);
        if (!m) {
            return
        }
        l = b[m]["url"];
        if (!a(el, m) && l) {
            if (b[m]["nw"]) {
                window.open(l)
            } else {
                window.location.href = l
            }
        }
        return true
    }
    function c(l) {
        var n = l.get("children").slice(-1).item(0);
        for (var m in b) {
            if (n.hasClass(m) || l.hasClass(m)) {
                return m
            }
        }
        return false
    }
    function a(l, m) {
        var n = b[m]["blockClass"];
        if (l.ancestor("." + n, true, "li")) {
            return true
        }
        return false
    }
    function k() {
        if (f === null) {
            f = false;
            var l = d.one(".ads.abdt"), m = null;
            if (l && l.get("clientHeight") === 0) {
                m = l.getComputedStyle("display");
                if (m && m.indexOf("none") > -1) {
                    f = true
                } else {
                    m = l.getComputedStyle("MozBinding");
                    if (m && m !== "none" && m.indexOf("elemhide") > -1) {
                        f = true
                    }
                }
            }
        }
        return f
    }
    function e(l) {
        if (l["class"]) {
            var m = d.all("." + l["class"] + " a");
            if (m) {
                m.each(function(n) {
                    n.removeAttribute("target")
                })
            }
        }
    }
    d.Search.ClickableBackground = {init: function(s) {
            if (k()) {
                e(s);
                return
            }
            var m = s.blockList ? s.blockList.split(",") : [], q, n, o, l = s.dataBid || null;
            if (i == 0) {
                var t = s.delegateElement || "#cols", r = s.delegateFilter || "li";
                d.delegate("mousedown", j, t, r);
                d.delegate("click", h, t, r)
            }
            if (s["class"]) {
                o = s["class"];
                n = d.one("." + o)
            } else {
                if (s.selector) {
                    n = d.one(s.selector);
                    if (n) {
                        o = Math.random().toString(36).slice(2);
                        n.addClass(o)
                    } else {
                        return
                    }
                } else {
                    return
                }
            }
            b[o] = s;
            i++;
            if (n) {
                n.setStyle("cursor", "pointer");
                q = n.ancestor("li") || null;
                if (q) {
                    if (l && !q.hasAttribute(l) && n.hasAttribute(l)) {
                        q.setAttribute(l, n.getAttribute(l))
                    } else {
                        if (!q.hasAttribute("data-bk") && n.hasAttribute("data-bk")) {
                            q.setAttribute("data-bk", n.getAttribute("data-bk"))
                        }
                        if (!q.hasAttribute("data-bns") && n.hasAttribute("data-bns")) {
                            q.setAttribute("data-bns", n.getAttribute("data-bns"))
                        }
                    }
                }
            }
            for (var p = 0; p < m.length; p++) {
                d.all("." + o + " " + m[p]).addClass(s.blockClass)
            }
        },reset: function() {
            b = {};
            i = 0
        }}
}, "1.0.0", {requires: ["event", "node"],optional: ["srp-bing-beacon"]});
