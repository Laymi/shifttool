Meteor.subscribe 'allShifts'
Template.Exchange.helpers
  initLeanModal: ->
    instance = Template.instance()
    Meteor.defer ->
      instance.$('.modal-trigger').leanModal()

  thisUsersShifts: ->
    currentUsersEmail = Meteor.users.findOne(Meteor.userId())?.emails?[0]?.address
    # console.log 'currentUsersEmail', currentUsersEmail
    currentStudentsId = Students.findOne('email':{$regex: new RegExp(currentUsersEmail, "i")})?._id
    # console.log 'currentStudentsId', currentStudentsId
    thisUsersShifts = Shifts.find('assignedStudents': $in: [ currentStudentsId ]).fetch()
    # console.log 'thisUsersShifts', thisUsersShifts
    if thisUsersShifts.length then thisUsersShifts else null

  exchangeableShifts: ->
    exchangeableShifts = Shifts.find({'listedAsExchangeableBy.0': {$exists: true}}).fetch()
    if exchangeableShifts.length then exchangeableShifts else null

  formatDate: (date) ->
    moment(date).subtract(2, 'hours').format('DD-MM-YYYY hh:mm:ss')

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

    Meteor.call 'initializeShiftTrade', currentStudentsId, Session.get('shiftToOfferFor'), event.target.name

    # console.log 'location.reload()'

    location.reload()


  "click #makeAnOffer": (event) ->
    shiftId = event.target.name
    Session.set('shiftToOfferFor', shiftId)
