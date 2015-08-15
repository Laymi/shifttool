@Students = new Mongo.Collection 'students'

if Meteor.isServer
  # XXX Temporary permission
  Students.allow
    insert: -> true
