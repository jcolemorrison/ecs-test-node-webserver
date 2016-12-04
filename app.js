// MODULES
var express = require('express');

// EXPRESS CONFIG
var app = express();

app.set('view engine', 'pug')
app.set('port', 5000);

// set up "ping" endpoint
app.get('/web', function (req, res) {
  res.send('server updated!')
});

// catch/handle 404
app.use(function (req, res, next) {
  res.status(404).send('404')
});

// catch/handle 500
app.use(function (err, req, res, next) {
  console.error(err.stack)
  res.status(500).send('500')
});

module.exports = app.listen(app.get('port'), function () {
  console.log('Node app is running on port', app.get('port'));
});