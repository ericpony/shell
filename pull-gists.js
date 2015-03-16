#! /usr/bin/node

var request = require('request'),
    fs = require('fs'),
    username = 'ericpony',
    dir = './gists';  // save gists here

var options = {
  url: 'https://api.github.com/users/' + username + '/gists',
  headers: {
    'User-Agent': 'User-Agent: Mozilla/5.0' // Got 403 without this header
  }
};

request(options, function(error, response, body) {

  if (!error && response.statusCode == 200) {
    try {
      gists = JSON.parse(body);
      gists.forEach(function (gist) {
        console.log('Description: ', gist.description);
        fs.mkdir(dir, function (err) {
          for (var file in gist.files) {
            var url = gist.files[file].raw_url;
            var filename = gist.files[file].filename;
            console.log('Downloading... ' + filename);
            request(url).pipe(fs.createWriteStream(dir + '/' + filename));
          }
        });
      });
    } catch(e) {
      console.log('Exception: ' + e);
    }
  } else
      console.log('Error ' + response.statusCode);
});
