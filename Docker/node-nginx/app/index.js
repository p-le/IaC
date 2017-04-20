const express = require('express');

const app = express();

app.set('port', process.env.PORT)

app.get('/', function (req, res) {
  res.send('Hello world\n');
});

const server = app.listen(app.get('port'), () => {
  console.log(`Running on http://${server.address().address}:${server.address().port}`);
})
