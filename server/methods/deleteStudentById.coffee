Meteor.methods
  deleteStudentById: (_id) ->
    if Meteor.users.findOne(Meteor.userId()).profile.role == 'admin'
      check _id, String
      Students.remove _id
