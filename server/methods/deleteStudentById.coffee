Meteor.methods
  deleteStudentById: (_id) ->
    check _id, String
    Students.remove _id
