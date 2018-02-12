# Set up requirejs to load the tests
# Uses heuristic that test filenames end with Tests.js
tests = []
for file of window.__karma__.files
  if window.__karma__.files.hasOwnProperty(file)
    if /Tests\.js$/.test(file)
      tests.push(file)

requirejs.config
  baseUrl: '/base/public/js'
  paths:
    "moment": "libs/moment-2.9.0"
  deps: tests
  callback: window.__karma__.start
