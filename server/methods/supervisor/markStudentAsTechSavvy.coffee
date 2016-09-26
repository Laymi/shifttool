Meteor.methods
  markStudentAsTechSavvy: (studentId)->
    check studentId, String

    if Meteor.users.findOne(Meteor.userId()).profile.role == 'admin' || Meteor.users.findOne(Meteor.userId()).profile.role == 'supervisor'
      isStudentAlreadyMarkedAsTechSavvy = Students.findOne(studentId)?.techSavvy
      if !isStudentAlreadyMarkedAsTechSavvy
        Students.update({"_id":studentId},{$set: {'techSavvy':true}})
      else
        Students.update({"_id":studentId},{$set: {'techSavvy':false}})
