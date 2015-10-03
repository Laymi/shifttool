Meteor.subscribe 'allShifts'
Template.Exchange.helpers
  initLeanModal: ->
    instance = Template.instance()
    Meteor.defer ->
      instance.$('.modal-trigger').leanModal()

  thisUsersShifts: ->
    currentUsersEmail = Meteor.users.findOne(Meteor.userId())?.emails?[0]?.address
    console.log 'currentUsersEmail', currentUsersEmail
    currentStudentsId = Students.findOne(email:currentUsersEmail)?._id
    console.log 'currentStudentsId', currentStudentsId
    thisUsersShifts = Shifts.find('assignedStudents': $in: [ currentStudentsId ]).fetch()
    console.log 'thisUsersShifts', thisUsersShifts
    if thisUsersShifts.length then thisUsersShifts else null

  exchangableShifts: ->
    exchangableShifts = Shifts.find(exchangable:true).fetch()
    if exchangableShifts.length then exchangableShifts else null

  formatDate: (date) ->
    moment(date).format('DD-MM-YYYY hh:mm:ss')

  currentUserIsThisStudent: ->
    currentUsersEmail = Meteor.users.findOne(Meteor.userId())?.emails?[0]?.address

    currentStudentsId = Router?.current()?.params?._id
    currentStudentsEmail = Students.findOne(currentStudentsId)?.email

    return currentUsersEmail == currentStudentsEmail

Template.Exchange.rendered = ->
  document.getElementById('searchStudent')?.value = ''
  Session.set('possibleStudents', undefined)

Template.Exchange.events
  "click #makeASpecificOffer": (event) ->
    currentUsersEmail = Meteor.users.findOne(Meteor.userId())?.emails?[0]?.address
    currentStudentsId = Students.findOne(email:currentUsersEmail)?._id
    # console.log 'student: ', currentStudentsId
    # console.log 'forShift: ', Session.get('shiftToOfferFor')
    # console.log 'offeredShift: ', event.target.name
    Meteor.call 'initializeShiftTrade', currentStudentsId, Session.get('shiftToOfferFor'),event.target.name

  "click #makeAnOffer": (event) ->
    shiftId = event.target.name
    Session.set('shiftToOfferFor', shiftId)

    #I hate this stupid package... will look for a new one later
    ###MaterializeModal.confirm
      title: 'Initialize shift exchange'
      message: 'Do you want to list your shift in the shift exchange?'
      callback: (yesNo) ->
          if yesNo
              Meteor.call "listShiftForExchange", shiftId
              #Materialize.toast("Glad to here it!", 3000, 'green')
          else
              Materialize.toast("Too bad")###
