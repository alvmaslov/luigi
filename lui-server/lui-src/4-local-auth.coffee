module.exports = (app) ->
  LocalStrategy = require('passport-local').Strategy
  passport = app.my_lib.passport
  authMiddleware = app.my_lib.authMiddleware
  hmn = app.my_lib.mng

  app.post("/api/login", (req, res, next) -> 
      passport.authenticate('local', (err, user, info) -> 
        #console.log( user );
        if (err) 
            console.log err
            return next(err);
        
        
        if (!user) 
            return res.status(400).send([user, "Cannot log in", info])
        
        #console.log( 'before login');
  #console.log( req.session );
        req.login(user, (err) -> 
            res.send("Logged in")
            console.log( 'after login');
            console.log( req.session );
            req.session.save()
        )
      )(req, res, next)
  )

  app.post("/api/register", (req, res, next) -> 
      passport.authenticate('local-signup', (err, user, info) -> 
        #console.log( user );
        if (err) 
            console.log err
            return next(err);
        
        
        if (!user) 
            return res.status(409).send([user, "Cannot register", info])
        
        #console.log( 'before login');
  #console.log( req.session );
        req.login(user, (err) -> 
            res.send("Registered")
            console.log( 'after register');
            console.log( req.session );
            req.session.save()
        )
      )(req, res, next)
  )

  app.get('/api/logout',  (req, res) ->
      req.logout();
      console.log("logged out")
      return res.send();
  );
  
  app.post("/api/save_user", authMiddleware, (req, res) => 
    user = await hmn.findUserById( req.session.passport.user )
    console.log 'api save user'
    console.log user
    console.log req.body
    if user.password != req.body.old_pass
      res.status(400).send( 'Wrong password' )
    else
      if req.body.new_pass?.length > 0 
        hmn.update_password( user._id, req.body.new_pass )
      hmn.update_user_info( user._id, req.body.name, req.body.email )
      res.send( {'saved': 'ok'} )
  )

  app.get( '/api/users', authMiddleware, ( req, res ) =>
    users = await hmn.getUsers()
    res.send({users})
  )
  
  app.get("/api/user", authMiddleware, (req, res) => 
      #user = users.find((user) => 
      #    return user.id == req.session.passport.user
      #)
      #console.log([user, req.session])
      #console.log 'api user'
      #console.log req.session
      user = await hmn.findUserById( req.session.passport.user )
      delete user.password
      res.send({user: user})
  )

  passport.use('local-signup', new LocalStrategy({
    usernameField : 'email',
    passwordField : 'password',
    passReqToCallback: true
    }, 
    (req, email, password, done) => 
      try 
        name = req.body.name;
        user = await hmn.createUser( name, email, password, 'None' );
        return done(null, user);
      catch error
        done(error);
    
  ));
    
  passport.use(new LocalStrategy({
      usernameField: 'email',
      passwordField: 'password',
      passReqToCallback: true
    }, 
    (req, username, password, done) => 
        console.log( 'hi from login' );
        user = await hmn.findUser( username, password )
        console.log user
        ###if( user.email == username && user.password == password )
          soi = user.socket_id;
          socket = null;
          if( soi )
            socket = io.sockets.connected[soi] 
          if( socket )
            socket.emit( 'logout2' )
          user.socket_id = req.body.socket_id;###
        
        if (user and user.role != 'None') 
            done(null, user)
        else
            done(null, false, {message: 'Incorrect username or password'})
        
    
  ))

  passport.serializeUser((user, done) ->
    done(null, user._id)
  )

  passport.deserializeUser((id, done) ->
    #user = users.find((user) ->
    #    return user._id == id
    #)
    user = await hmn.findUserById( id )

    done(null, user)
  )
