#!/usr/bin/env node

var request  = require('request'), fs = require('fs');
var username = process.argv[2];
var dir      = process.argv[3] || './gists';  // save gists here

if(!username) {
  console.error('usage: ./' + process.argv[1].match(/[^\/\\]+$/)[0] + ' username (output-dir)');
  process.exit(1);
}

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
      gists.forEach(function(gist) {
        fs.mkdir(dir, function(err) {
          console.error('Gist url:    ', gist.url);
          console.error('Description: ', gist.description || 'none');
          console.error('Last update: ', gist.updated_at.match(/^\d+\-\d+\-\d\d/)[0]);
          for (var file in gist.files) {
            var url = gist.files[file].raw_url;
            var filename = gist.files[file].filename;
            console.error('File:         ' + filename);
            request(url).pipe(fs.createWriteStream(dir + '/' + filename));
          }
          console.error("------------");
        });
      });
    } catch(e) {
      console.error('Exception: ' + e);
    }
    return;
  }
  console.error('Error ' + response.statusCode);
});
