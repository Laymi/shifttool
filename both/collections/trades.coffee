@Trades = new Mongo.Collection 'trades'

if Meteor.isServer
  # XXX Temporary permission
  Trades.allow
    insert: -> true
