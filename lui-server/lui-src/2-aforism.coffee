module.exports = ( app, mng ) ->
  app.get( '/api/aforisms', 
    ( req, res ) =>
      #pid = req.query.pid
      #console.log req.query
      x = await mng.getAforisms( )
      res.send( x )
  )
  app.post( '/api/share', (req, res) =>
     txt = req.body.txt
     x = await mng.createAforism( txt )
     res.send( {'saved': 'ok'} )
  )
