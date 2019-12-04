module.exports = class Auth
  constructor: (app, mng) ->
  
    @mng = mng
  
    bodyParser = require('body-parser')
    app.use(bodyParser.json())
  
    session = require("express-session");
    MongoDBStore = require('connect-mongodb-session')(session);
    store = new MongoDBStore({
      uri: 'mongodb://localhost:27017/dube',
      collection: 'mySessions'
    });
    store.on('error', (error) ->
      console.log(error);
    );
    app.use(session({
      secret: 'This is a secret',
      cookie: {
        maxAge: 1000 * 60 * 60 * 24 # 1 day
      },
      store: store,
      # Boilerplate options, see:
      # * https://www.npmjs.com/package/express-session#resave
      # * https://www.npmjs.com/package/express-session#saveuninitialized
      resave: true,
      saveUninitialized: true
    }));

    @passport = require('passport')
    app.use(@passport.initialize());
    app.use(@passport.session());

  authMiddleware: (req, res, next) => 
    console.log( '### auth ###' );
    #console.log( req.session );
    if (!req.isAuthenticated()) 
        res.status(401).send('You are not authenticated')
    else 
        return next()

