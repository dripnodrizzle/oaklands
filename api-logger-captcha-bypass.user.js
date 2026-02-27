// ==UserScript==
// @name         API Logger & Captcha Bypass
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Log all API calls and auto-bypass captcha callbacks
// @author       Copilot
// @match        http://*.*/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // Intercept fetch
    const origFetch = window.fetch;
    window.fetch = async function(input, init) {
        let url = typeof input === "string" ? input : input.url;
        console.log("[API Logger] fetch:", url, init);
        return origFetch.apply(this, arguments);
    };

    // Intercept XMLHttpRequest
    const origOpen = XMLHttpRequest.prototype.open;
    const origSend = XMLHttpRequest.prototype.send;
    XMLHttpRequest.prototype.open = function(method, url, ...rest) {
        this._apiLoggerUrl = url;
        this._apiLoggerMethod = method;
        return origOpen.apply(this, [method, url, ...rest]);
    };
    XMLHttpRequest.prototype.send = function(body) {
        console.log("[API Logger] xhr:", this._apiLoggerMethod, this._apiLoggerUrl, body);
        return origSend.apply(this, arguments);
    };

    // Wait for captcha callback functions to be defined, then call them
    function tryBypassCaptcha() {
        let called = false;
        if (typeof window.captchaCompleted === "function") {
            window.captchaCompleted("dummy-captcha-token");
            called = true;
            console.log("[Captcha Bypass] captchaCompleted called");
        }
        if (typeof window.captchaCompletedFr === "function") {
            window.captchaCompletedFr("dummy-captcha-token");
            called = true;
            console.log("[Captcha Bypass] captchaCompletedFr called");
        }
        return called;
    }

    // Try immediately, then poll for up to 10 seconds
    if (!tryBypassCaptcha()) {
        let tries = 0;
        const interval = setInterval(() => {
            if (tryBypassCaptcha() || ++tries > 100) {
                clearInterval(interval);
            }
        }, 100);
    }
})();
