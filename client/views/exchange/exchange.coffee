Meteor.subscribe 'allShifts'
Template.Exchange.helpers
  exchangableShifts: ->
    exchangableShifts = Shifts.find(exchangable:true).fetch()
    if exchangableShifts.length then exchangableShifts else null

  userId: ->
    Router?.current()?.params?._id

  first_name: ->
    Students.findOne(Router?.current()?.params?._id).first_name

  last_name: ->
    Students.findOne(Router?.current()?.params?._id).last_name

  formatDate: (date) ->
    moment(date).format('DD-MM-YYYY hh:mm:ss')

  currentUserIsThisStudent: ->
    currentUsersEmail = Meteor.users.findOne(Meteor.userId()).emails[0].address

    currentStudentsId = Router?.current()?.params?._id
    currentStudentsEmail = Students.findOne(currentStudentsId).email

    return currentUsersEmail == currentStudentsEmail

Template.Exchange.rendered = ->
  document.getElementById('searchStudent').value = ''
  Session.set('possibleStudents', undefined)

Template.Exchange.events
  "click #listShiftForExchange": (event) ->
    shiftId = event.target.name

    console.log 'shiftId', shiftId

    #I hate this stupid package... will look for a new one later
    MaterializeModal.confirm
      title: 'Initialize shift exchange'
      message: 'Do you want to list your shift in the shift exchange?'
      callback: (yesNo) ->
          if yesNo
              Meteor.call "listShiftForExchange", shiftId
              #Materialize.toast("Glad to here it!", 3000, 'green')
          else
              Materialize.toast("Too bad")
