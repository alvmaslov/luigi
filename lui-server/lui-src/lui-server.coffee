express = require('express')
Mng = require('./1-mongo.coffee')
Afo = require('./2-aforism.coffee')
Auth = require('./3-auth.coffee')
localAuth = require( './4-local-auth.coffee')

mng = new Mng()

# creating an express instance
app = express()

auth = new Auth( app, mng )
app.my_lib = auth
localAuth( app )

Afo( app, mng )

#publicRoot = '/home/alexey/gitlab/vid-sub/v-client/dist'
conf = require('../conf.json')
publicRoot = conf.rootpath

app.use(express.static(publicRoot))


http = require('http').createServer(app);

http.listen(3200, () => 
  console.log("Luigi server listening on port 3200")
)

