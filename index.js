#!/usr/bin/env node

var exec = require('child_process').exec;

function runBuild(component) {
  var ps = exec('bash ./node_modules/fh-build/build.sh ' + component, function(err) {
    if (err) {
      throw new Error("Error when running the script: " + err);
    }
  });
  ps.stdout.on('data', function(data) {
    console.log(data);
  });
  ps.stderr.on('data', function(data) {
    console.log(data);
  });
}

module.exports = runBuild;
