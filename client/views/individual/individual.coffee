#Meteor.subscribe 'allShifts'
Template.Individual.helpers
  shifts: ->
    shifts = Shifts.find({'assignedStudents': $in: [ Router?.current()?.params?._id ]},{sort: {'info.start': 1}}).fetch()
    if shifts.length then shifts else null

  userId: ->
    Router?.current()?.params?._id

  first_name: ->
    Students.findOne(Router?.current()?.params?._id).first_name

  last_name: ->
    Students.findOne(Router?.current()?.params?._id).last_name

  formatDate: (date) ->
    moment(date).subtract(2, 'hours').format('MM-DD-YYYY hh:mm:ss a')

  currentUserIsThisStudent: ->
    currentUsersEmail = Meteor.users.findOne(Meteor.userId()).emails[0].address

    currentStudentsId = Router?.current()?.params?._id
    currentStudentsEmail = Students.findOne(currentStudentsId).email

    # console.log 'currentUsersEmail', currentUsersEmail
    # console.log 'currentStudentsEmail', currentStudentsEmail

    return currentUsersEmail.toLowerCase() == currentStudentsEmail.toLowerCase()

Template.Individual.rendered = ->
  document.getElementById('searchStudent').value = ''
  Session.set('possibleStudents', undefined)

Template.Individual.events
  "click #listShiftForExchange": (event) ->
    shiftId = event.currentTarget.name
    # console.log 'shiftId', shiftId

    #I hate this stupid package... look for a new one later or use leanModal
    MaterializeModal.confirm
      title: 'Initialize shift exchange'
      message: 'Do you want to list your shift in the shift exchange?'
      callback: (yesNo) ->
          if yesNo
              Meteor.call "listShiftForExchange", shiftId, Router?.current()?.params?._id
              Router.go('exchange');
          else
              Materialize.toast("Too bad")
