Template.Home.helpers
  shifts: ->
    userId = Meteor.userId()
    userEmail = Meteor.users.find(userId)?.fetch()?.emails?[0]?.address
    studentId = Students.findOne('email':{$regex: new RegExp(userEmail, "i")})?._id

    shifts = Shifts.find({'assignedStudents': $in: [ studentId ]},{sort: {'info.start': 1}}).fetch()
    if shifts.length then shifts else null

  userId: ->
    userId = Meteor.userId()
    userEmail = Meteor.users.find(userId)?.fetch()?.emails?[0]?.address
    studentId = Students.findOne('emails':userEmail)._id
    studentId

  first_name: ->
    userId = Meteor.userId()
    userEmail = Meteor.users.find(userId)?.fetch()?.emails?[0]?.address
    studentId = Students.findOne('emails':userEmail)._id
    Students.findOne(studentId).first_name

  last_name: ->
    userId = Meteor.userId()
    userEmail = Meteor.users.find(userId)?.fetch()?.emails?[0]?.address
    studentId = Students.findOne('emails':userEmail)._id
    Students.findOne(studentId).last_name

  formatDate: (date) ->
    moment(date).subtract(2, 'hours').format('MM-DD-YYYY hh:mm:ss a')

  currentUserIsThisStudent: ->
    currentUsersEmail = Meteor.users.findOne(Meteor.userId()).emails[0].address

    userId = Meteor.userId()
    userEmail = Meteor.users.find(userId)?.fetch()?.emails?[0]?.address
    studentId = Students.findOne('email':{$regex: new RegExp(userEmail, "i")})?._id

    currentStudentsEmail = Students.findOne(studentId).email

    # console.log 'currentUsersEmail', currentUsersEmail
    # console.log 'currentStudentsEmail', currentStudentsEmail

    return currentUsersEmail.toLowerCase() == currentStudentsEmail.toLowerCase()

Template.Home.events
  "click #listShiftForExchange": (event) ->
    shiftId = event.currentTarget.name
    # console.log 'shiftId', shiftId

    userId = Meteor.userId()
    userEmail = Meteor.users.find(userId)?.fetch()?.emails?[0]?.address
    studentId = Students.findOne('email':{$regex: new RegExp(userEmail, "i")})?._id

    #I hate this stupid package... look for a new one later or use leanModal
    MaterializeModal.confirm
      title: 'Initialize shift exchange'
      message: 'Do you want to list your shift in the shift exchange?'
      callback: (yesNo) ->
          if yesNo
              Meteor.call "listShiftForExchange", shiftId, studentId
              Router.go('exchange');
          else
              Materialize.toast("Too bad")
