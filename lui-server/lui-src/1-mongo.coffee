ObjectID = require('mongodb').ObjectID
module.exports = class Mng
  constructor: () ->
    MongoClient = require("mongodb").MongoClient;
    url = "mongodb://localhost:27017/";
    mongoClient = new MongoClient(url, { 
      useNewUrlParser: true,
      useUnifiedTopology: true});
    #x = @
    mongoClient.connect( (err, client) =>
      return console.log err if err
      @x = 5
      @client = client
      #console.log @client
      @db = client.db("luigi");
      console.log 'connected to mongodb://localhost:27017/luigi'
    )
# auth    
  createUser: ( name, email, password, role ) ->
    @db.collection("users").insertOne( { name, email, password, role } )
  findUser: ( email, password ) ->
    @db.collection("users").findOne( { email, password } )
  findUserById: (id) ->
    @db.collection("users").findOne( { _id: id } )
  getUsers: ->
    x = @db.collection("users").find({},{projection: {name:1,email:1,role:1}}).toArray()
  isManager: ( user_id ) ->
    user = await @findUserById( user_id )
    return false if !user
    return user.role == 'Manager'
  update_password: ( user_id, new_pass ) ->
    @db.collection("users").updateOne( { _id: user_id }, { $set: {'password': new_pass }} )
  update_user_info: (user_id, name, email ) ->
    @db.collection("users").updateOne( { _id: user_id }, { $set: {name,email} } )
  update_role: ( email, role ) ->
    @db.collection("users").updateOne( { email }, {$set: { role } } )
    #console.log email, role
  createAforism: (txt) ->
    @db.collection('afo').insertOne({ txt })
  getAforisms: ->
    @db.collection('afo').find().toArray()
