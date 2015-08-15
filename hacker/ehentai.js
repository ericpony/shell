#!/usr/bin/env phantomjs

var webpage = require('webpage');
var args = require("system").args;
var fs = require("fs");
var spawn = require("child_process").spawn;

var outputPath = '';

function printUsage() {
    console.log("Usage: " + args[0] + " gallery_url [output_dir]");
}

function downloadFinished() {
    console.log("Download done! Enjoy you \"happy time\"!");
    phantom.exit();
}

function getComicName(page) {
    var comicName = page.evaluate(function() {
        var nameToReturn;

        if (document.getElementById("gj").innerHTML !== "")
            nameToReturn = document.getElementById("gj").innerHTML;
        else
            nameToReturn = document.getElementById("gn").innerHTML;

        return nameToReturn;
    });

    return comicName;
}

function start(url, outputPath) {
    var page = webpage.create();

    page.open(url, function(status) {
        if (status !== "success") {
            console.log("Connection to " + url + " failed");
            phantom.exit(1);
        }

        var firstPageUrl = page.evaluate(function() {
            return document.getElementById("gdt").getElementsByTagName('a')[0].href;
        });
        var comicName = getComicName(page);

        if (outputPath) {
            outputPath += (fs.separator + comicName);
            fs.makeTree(outputPath);
            fs.changeWorkingDirectory(outputPath);
        }

        console.log("Start downloading " + comicName);
        downloadPage(firstPageUrl);
    });
}

function downloadPage(url) {
    var page = webpage.create();

    page.open(url, function() {
        var nextPageUrl = page.evaluate(function() {
            var dom = document.getElementById("img").parentNode;
            var e = document.createEvent('MouseEvents');

            /* Need clicking to trigger js code, otherwise we'll be banned */
            e.initMouseEvent('click', true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
            dom.dispatchEvent(e);

            return dom.href;
        });
        var imgUrl = page.evaluate(function() {
            return document.getElementById("img").src;
        });
        var imgName = imgUrl.split("/")[imgUrl.split("/").length - 1];

        console.log("Downloading page: " + imgName);
        var child = spawn("wget", [imgUrl, "-O", imgName]);
        child.on("exit", function(code) {
            if (nextPageUrl === page.url)
                downloadFinished();
        });

        if (nextPageUrl !== page.url)
            downloadPage(nextPageUrl);
    });
}

if (args.length > 1) {
    var mainPageUrl = args[1];
    var outputPath = args[2];

    start(mainPageUrl, outputPath);
} else {
    printUsage();
    phantom.exit();
}
