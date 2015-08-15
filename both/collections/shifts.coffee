@Shifts = new Mongo.Collection 'shifts'

if Meteor.isServer
  # XXX Temporary permission
  Shifts.allow
    insert: -> true
