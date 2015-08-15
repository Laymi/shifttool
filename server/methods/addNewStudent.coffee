Meteor.methods
  addNewStudent: (newStudent) ->
    check newStudent, Object
    Students.insert newStudent
