# XXX Temporary publication
Meteor.publish 'allStudents', ->
  if this.userId
    Students.find()
  else
    @ready()
